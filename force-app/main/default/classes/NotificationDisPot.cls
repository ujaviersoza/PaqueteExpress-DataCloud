/**
 * @description       : NOTIFICACIÓN RENTABILIDAD AUTORIZADA
 * @group             : Freeway Consulting
 * Ver   Date         Author                               Modification
 * 1.0   01-06-2021   msalinas@freewayconsulting.com	   Initial Version
 * 2.0	 14-04-2023	  msalinas@freewayconsulting.com	   Update classDescuento
**/

public class NotificationDisPot implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    public String query;
    public string dfecha;
    public string dfecha2;
    public Date fcha;
    public Date fcha2;
    public List<Tarifario__c> listTarifasExpress = new List<Tarifario__c>();
    public Cotizador__c ObjCostos = new Cotizador__c();
    public Map<String, Map<String, Tarifario_general_terrestre__c>> mapTarifarioT = new Map<String, Map<String, Tarifario_general_terrestre__c>>();
    public Map<Id, List<Opportunity>> oppsByAcc = new Map<Id, List<Opportunity>>(); //Todas las cuentas y sus opps procesadas para pasar al siguiente batch
    public List<Opportunity> oppsToUpdateList = new List<Opportunity>(); // Oportunidades procesadas totales para adjunto en mail
    
    public NotificationDisPot(){
        for(Tarifario_general_terrestre__c objTarifarioT: queryTarifarioTFull()){
                if(!mapTarifarioT.containsKey(objTarifarioT.Tarifa__c)){
                    mapTarifarioT.put(objTarifarioT.Tarifa__c, new Map<String, Tarifario_general_terrestre__c>{objTarifarioT.RangoKM__c => objTarifarioT});
                } else if (!mapTarifarioT.get(objTarifarioT.Tarifa__c).containsKey(objTarifarioT.RangoKM__c)){
                    mapTarifarioT.get(objTarifarioT.Tarifa__c).put(objTarifarioT.RangoKM__c, objTarifarioT);
                }
            }
        
        listTarifasExpress = queryTarifarioExpress();
        ObjCostos  = [SELECT EntregaDomicilioZonaPlus__c, SeguroMillarDeclarado__c, IVA__c, EAD__c, RAD__c, CoeficientePV__c, MinEAD__c, MinRAD__c FROM Cotizador__c LIMIT 1];
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        fcha = Date.today().addDays(-186);
        fcha2 = Date.today().addDays(-180);
        dfecha = String.valueOf(fcha);
        dfecha2 = String.valueOf(fcha2);
        query = 'SELECT Id, Name, CloseDate, StageName, SBQQ__PrimaryQuote__c, SBQQ__PrimaryQuote__r.Name, SBQQ__PrimaryQuote__r.Tipo_de_documentacion__c, ' +
            	'AccountId, Account.Name, Account.Id_SIpWeb__c, Account.Tipo_cotizador__c, SBQQ__PrimaryQuote__r.Modelo_de_tarifas__c, ' +
            	'SBQQ__PrimaryQuote__r.SBQQ__Status__c, SBQQ__PrimaryQuote__r.PAQ_DescuentoGlobal__c, SBQQ__PrimaryQuote__r.Ingreso_Mensual__c, ' +
            	'SendEmailPotencial__c, SendEmailDescuento__c, Tipo_de_documentacion__c, Descuento_real__c, Desfase__c, Venta_promedio_real__c ' +
            	'FROM Opportunity WHERE StageName = \'Cerrada/Ganada\' ' +
            	'AND SBQQ__PrimaryQuote__r.SBQQ__Status__c = \'Approved\' ';
        
        if(!Test.isRunningTest()){
            query += 'AND CloseDate >= ' + dfecha + ' AND CloseDate <= ' + dfecha2;
        } else { query += 'LIMIT 50'; }
        system.debug('FINAL QUERY: ' + query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Opportunity> records){
        Decimal DescuentoReal;
        Decimal DescuentoCotizado;
        List<Opportunity> oppsToUpdate = new List<Opportunity>(); //Lista de oportunidades a actualizar en este lote
        Map<Id, List<Opportunity>> oppsByAccInt = new Map<Id, List<Opportunity>>(); //Cuentas y opps procesadas solo en este lote
        for(Opportunity opp : records){
            if(!oppsByAcc.containsKey(opp.AccountId)){
            	oppsByAcc.put(opp.AccountId, new List<Opportunity>());
                oppsByAccInt.put(opp.AccountId, new List<Opportunity>());
            }
            oppsByAcc.get(opp.AccountId).add(opp);
            if(!oppsByAccInt.containsKey(opp.AccountId))
                oppsByAccInt.put(opp.AccountId, new List<Opportunity>());
            oppsByAccInt.get(opp.AccountId).add(opp);
        }
        
        //Obtener el descuento real de cada cotización por cliente...
        for(Id acId: oppsByAccInt.keyset()){
                for(Opportunity acOpp: oppsByAccInt.get(acId)){
                    DescuentoReal = 0;
        			DescuentoCotizado = 0;
                    Decimal cDescuento = 0;
                    System.debug('ACCOUNT: ' + acOpp.Account.Id_SIpWeb__c);
                    System.debug('QUOTE: ' + acOpp.SBQQ__PrimaryQuote__r.Name);
                    System.debug('TIPO DE DOCUMENTACIÓN: ' + acOpp.Tipo_de_documentacion__c);
                    System.debug('MODELO DE TARIFAS: ' + acOpp.SBQQ__PrimaryQuote__r.Modelo_de_tarifas__c);
                    if(acOpp.Tipo_de_documentacion__c == 'En Piso-Sipweb'){
                        //Si el tipo de documentación es Sipweb, el descuento que se calcule debe ser el BI
                        //Esto se hace en el siguiente batch donde se procesan ventas
                    } else {
                        if(acOpp.Tipo_de_documentacion__c == 'Guías prepagadas'){ 
                            cDescuento = classDescuento3.getDescuentoRealPP(acId, acOpp.SBQQ__PrimaryQuote__c, this.fcha, this.fcha2, this.mapTarifarioT, this.ObjCostos, this.listTarifasExpress);              	
                        } else if(acOpp.Tipo_de_documentacion__c == 'Documentación Remota'){
                            if(acOpp.SBQQ__PrimaryQuote__r.Modelo_de_tarifas__c == 'Costo base más excedente: Por Destinos / Por rangos de km'){
                                cDescuento = classDescuento3.getDescuentoRealCBME(acId, acOpp.SBQQ__PrimaryQuote__c, this.fcha, this.fcha2, this.mapTarifarioT, this.ObjCostos, this.listTarifasExpress);
                            } else if(acOpp.SBQQ__PrimaryQuote__r.Modelo_de_tarifas__c == 'Guía multipieza: Por Destinos / Por Rangos de km'){
                                cDescuento = classDescuento3.getDescuentoRealGMP(acId, acOpp.SBQQ__PrimaryQuote__c, this.fcha, this.fcha2, this.mapTarifarioT, this.ObjCostos, this.listTarifasExpress);
                            } else {
                                cDescuento = classDescuento3.getDescuentoRealWW(acId, acOpp.SBQQ__PrimaryQuote__c, this.fcha, this.fcha2, this.mapTarifarioT, this.ObjCostos, this.listTarifasExpress);
                        	}
                        }
                        DescuentoReal = Math.abs(cDescuento)*100;
                        acOpp.Descuento_real__c = DescuentoReal;
                        DescuentoCotizado = acOpp.SBQQ__PrimaryQuote__r.PAQ_DescuentoGlobal__c;
                        if(DescuentoCotizado != null){
                            acOpp.Desfase__c = Math.abs(DescuentoReal - DescuentoCotizado);
                            if(DescuentoReal >= (DescuentoCotizado + 5)){
                                //El descuento real excede la cotización, notifica al usuario
                                acOpp.SendEmailDescuento__c = true;
                                oppsToUpdate.add(acOpp);
                            }
                        } oppsToUpdateList.add(acOpp);
                    }
                }
        } if(oppsToUpdate.size()>0){Database.update(oppsToUpdate, false);}
    }
    
    public void finish(Database.BatchableContext BC){
        
        try{
            string header = 'Record Id, Name, Account, Quote, Documentation type, Descuento cotizado, Descuento real, Desfase, Send Email \n';
			string finalstr = header ;
			for(Opportunity o: oppsToUpdateList){
                string recordString = o.id + ',' + o.Name + ',' + o.Account.Id_SIpWeb__c + ',' + o.SBQQ__PrimaryQuote__r.Name + ',' + o.Tipo_de_documentacion__c + ',' + 
                    o.SBQQ__PrimaryQuote__r.PAQ_DescuentoGlobal__c + ','+ o.Descuento_real__c + ','+ o.Desfase__c + ',' + o.SendEmailDescuento__c +'\n';
				finalstr = finalstr +recordString;
            }
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
			blob csvBlob = Blob.valueOf(finalstr);
			string csvname= 'Opps3.csv';
			csvAttc.setFileName(csvname);
			csvAttc.setBody(csvBlob);
            //Send an email to the Apex job's submitter notifying of job completion.
           // Query the AsyncApexJob object to retrieve the current job's information.
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                TotalJobItems, ExtendedStatus, CreatedBy.Email
                                FROM AsyncApexJob WHERE Id =:BC.getJobId()];
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               String[] toAddresses;
               toAddresses = Label.Send_notification.split(',', 0);
               mail.setToAddresses(toAddresses);
               mail.setSubject('Apex Notification Autorized Discount: ' + a.Status);
               mail.setPlainTextBody
               ('The batch Apex job processed ' + a.TotalJobItems +
               ' batches with '+ a.NumberOfErrors + ' failures .EXTENDEDSTATUS: ' + a.ExtendedStatus);
               mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
               Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            //Llama el batch que valida el potencial real vs el potencial autorizado
            NotificationDisPot2 batch2 = new NotificationDisPot2(oppsByAcc);
            if(!test.isRunningTest()) database.executeBatch(batch2);
            
        } catch (Exception ex){
            System.debug('Error en finish ' + + ex.getLineNumber()+' '+ex.getMessage());
        }
    }
    
    public static List<Tarifario_general_terrestre__c> queryTarifarioTFull(){
        return [SELECT  Id
        , Tarifa__c
        , Flete__c
        , Name
        , PesoMaximo__c
        , VolumenMaximo__c
        , RangoKM__c
        FROM Tarifario_general_terrestre__c WHERE Year__c = null];
    }
    
    public static List<Tarifario__c> queryTarifarioExpress(){
        return [SELECT  Id
        , Tarifa__c
        , GuiaDeArranque1Kg__c
        , Kg_adicional__c
        , Rango_km__c
        , year__c
        FROM Tarifario__c WHERE year__c = null];
    }
}