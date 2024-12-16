@isTest
(SeeAllData=true)
public class NotificationDisPot_Test {
    
    @IsTest
    static void pruebaDisPot(){
        Test.startTest();
        
        NotificationDisPot BT = new NotificationDisPot();
		Database.executeBatch (BT);
        
        Test.stopTest();
    }
    
    @IsTest
    static void pruebaClassDescuento3PP(){
        Test.startTest();
        List<Tarifario__c> listTarifasExpress = new List<Tarifario__c>();
    	Cotizador__c ObjCostos = new Cotizador__c();
    	Map<String, Map<String, Tarifario_general_terrestre__c>> mapTarifarioT = new Map<String, Map<String, Tarifario_general_terrestre__c>>();
        
        for(Tarifario_general_terrestre__c objTarifarioT: queryTarifarioTFull()){
        	if(!mapTarifarioT.containsKey(objTarifarioT.Tarifa__c)){
            	mapTarifarioT.put(objTarifarioT.Tarifa__c, new Map<String, Tarifario_general_terrestre__c>{objTarifarioT.RangoKM__c => objTarifarioT});
            } else if (!mapTarifarioT.get(objTarifarioT.Tarifa__c).containsKey(objTarifarioT.RangoKM__c)){
            	mapTarifarioT.get(objTarifarioT.Tarifa__c).put(objTarifarioT.RangoKM__c, objTarifarioT);
            }
        }
        
        listTarifasExpress = queryTarifarioExpress();
        ObjCostos  = [SELECT EntregaDomicilioZonaPlus__c, SeguroMillarDeclarado__c, IVA__c, EAD__c, RAD__c, CoeficientePV__c, MinEAD__c, MinRAD__c FROM Cotizador__c LIMIT 1];
    	Date fcha = Date.newInstance(2021, 01, 01);
        Date fcha2 = Date.newInstance(2021, 04, 30);
        
        //ID DC: a13WA00000U4ilxYAB, ID QA: a134C0000014uXsQAI, ID PROD: a132E000006MQWYQA4
        SBQQ__Quote__c Quote1 = [SELECT Id, SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = 'a13WA00000U4ilxYAB'];
        classDescuento3.getDescuentoRealPP(Quote1.SBQQ__Account__c, Quote1.Id, fcha, fcha2, mapTarifarioT, ObjCostos, listTarifasExpress);
        
        //ID DC: a13WA00000U4ilxYAB, ID DC: a13WA00000U4ilxYAB, ID QA: a134C0000014uY7QAI, ID PROD: a132E000006MPfKQAW
        SBQQ__Quote__c Quote2 = [SELECT Id, SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = 'a13WA00000U4ilxYAB'];
        classDescuento3.getDescuentoRealPP(Quote2.SBQQ__Account__c, Quote2.Id, fcha, fcha2, mapTarifarioT, ObjCostos, listTarifasExpress);
        
        //ID DC: a13WA00000U4ilxYAB, ID DC: a13WA00000U4ilxYAB, ID DC: a13WA00000U4ilxYAB, ID QA: a134C0000014uY6QAI, ID PROD: a132E000006MPf3QAG
        SBQQ__Quote__c Quote3 = [SELECT Id, SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = 'a13WA00000U4ilxYAB'];
        classDescuento3.getDescuentoRealPP(Quote3.SBQQ__Account__c, Quote3.Id, fcha, fcha2, mapTarifarioT, ObjCostos, listTarifasExpress);
        
        //ID DC: a13WA00000U4ilxYAB, ID DC: a13WA00000U4ilxYAB, ID QA: a134C0000014uY5QAI, ID PROD: a134U000009ggrQQAQ
        SBQQ__Quote__c Quote4 = [SELECT Id, SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = 'a13WA00000U4ilxYAB'];
        classDescuento3.getDescuentoRealPP(Quote4.SBQQ__Account__c, Quote4.Id, fcha, fcha2, mapTarifarioT, ObjCostos, listTarifasExpress);
    	Test.stopTest();
    }
    
    @IsTest
    static void pruebaClassDescuento3WW(){
        Test.startTest();
        List<Tarifario__c> listTarifasExpress = new List<Tarifario__c>();
    	Cotizador__c ObjCostos = new Cotizador__c();
    	Map<String, Map<String, Tarifario_general_terrestre__c>> mapTarifarioT = new Map<String, Map<String, Tarifario_general_terrestre__c>>();
        
        for(Tarifario_general_terrestre__c objTarifarioT: queryTarifarioTFull()){
        	if(!mapTarifarioT.containsKey(objTarifarioT.Tarifa__c)){
            	mapTarifarioT.put(objTarifarioT.Tarifa__c, new Map<String, Tarifario_general_terrestre__c>{objTarifarioT.RangoKM__c => objTarifarioT});
            } else if (!mapTarifarioT.get(objTarifarioT.Tarifa__c).containsKey(objTarifarioT.RangoKM__c)){
            	mapTarifarioT.get(objTarifarioT.Tarifa__c).put(objTarifarioT.RangoKM__c, objTarifarioT);
            }
        }
        
        listTarifasExpress = queryTarifarioExpress();
        ObjCostos  = [SELECT EntregaDomicilioZonaPlus__c, SeguroMillarDeclarado__c, IVA__c, EAD__c, RAD__c, CoeficientePV__c, MinEAD__c, MinRAD__c FROM Cotizador__c LIMIT 1];
    	Date fcha = Date.newInstance(2021, 01, 01);
        Date fcha2 = Date.newInstance(2021, 04, 30);
        
        //ID DC: a13WA00000U4ilxYAB, ID QA: a134C0000014uXrQAI, ID PROD: a132E00000BbTnhQAF
        SBQQ__Quote__c Quote1 = [SELECT Id, SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = 'a13WA00000U4ilxYAB'];
        classDescuento3.getDescuentoRealWW(Quote1.SBQQ__Account__c, Quote1.Id, fcha, fcha2, mapTarifarioT, ObjCostos, listTarifasExpress);
        
        //ID DC: a13WA00000U4ilxYAB, ID QA: a134C0000014putQAA, ID PROD: a132E000008iGWJQA2
        SBQQ__Quote__c Quote2 = [SELECT Id, SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = 'a13WA00000U4ilxYAB'];
        classDescuento3.getDescuentoRealWW(Quote2.SBQQ__Account__c, Quote2.Id, fcha, fcha2, mapTarifarioT, ObjCostos, listTarifasExpress);
        
        //ID DC: a13WA00000U4ilxYAB, ID QA: a134C0000014qr1QAA, ID PROD: a132E000006MPdWQAW
        SBQQ__Quote__c Quote3 = [SELECT Id, SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = 'a13WA00000U4ilxYAB'];
        classDescuento3.getDescuentoRealWW(Quote3.SBQQ__Account__c, Quote3.Id, fcha, fcha2, mapTarifarioT, ObjCostos, listTarifasExpress);
    	Test.stopTest();
    }
    
    @IsTest
    static void pruebaClassDescuento3CBME(){
        Test.startTest();
        List<Tarifario__c> listTarifasExpress = new List<Tarifario__c>();
    	Cotizador__c ObjCostos = new Cotizador__c();
    	Map<String, Map<String, Tarifario_general_terrestre__c>> mapTarifarioT = new Map<String, Map<String, Tarifario_general_terrestre__c>>();
        
        for(Tarifario_general_terrestre__c objTarifarioT: queryTarifarioTFull()){
        	if(!mapTarifarioT.containsKey(objTarifarioT.Tarifa__c)){
            	mapTarifarioT.put(objTarifarioT.Tarifa__c, new Map<String, Tarifario_general_terrestre__c>{objTarifarioT.RangoKM__c => objTarifarioT});
            } else if (!mapTarifarioT.get(objTarifarioT.Tarifa__c).containsKey(objTarifarioT.RangoKM__c)){
            	mapTarifarioT.get(objTarifarioT.Tarifa__c).put(objTarifarioT.RangoKM__c, objTarifarioT);
            }
        }
        
        listTarifasExpress = queryTarifarioExpress();
        ObjCostos  = [SELECT EntregaDomicilioZonaPlus__c, SeguroMillarDeclarado__c, IVA__c, EAD__c, RAD__c, CoeficientePV__c, MinEAD__c, MinRAD__c FROM Cotizador__c LIMIT 1];
    	
        //ID DC: a13WA00000U4ilxYAB, ID QA: a134U000008FlrlQAC, ID PROD: a134U000009jZfHQAU
        SBQQ__Quote__c Quote = [SELECT Id, SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = 'a13WA00000U4ilxYAB'];
        Date fcha = Date.newInstance(2021, 01, 01);
        Date fcha2 = Date.newInstance(2021, 04, 30);
        classDescuento3.getDescuentoRealCBME(Quote.SBQQ__Account__c, Quote.Id, fcha, fcha2, mapTarifarioT, ObjCostos, listTarifasExpress);
    	Test.stopTest();
    }
    
    @IsTest
    static void pruebaClassDescuento3GMP(){
        Test.startTest();
        List<Tarifario__c> listTarifasExpress = new List<Tarifario__c>();
    	Cotizador__c ObjCostos = new Cotizador__c();
    	Map<String, Map<String, Tarifario_general_terrestre__c>> mapTarifarioT = new Map<String, Map<String, Tarifario_general_terrestre__c>>();
        
        for(Tarifario_general_terrestre__c objTarifarioT: queryTarifarioTFull()){
        	if(!mapTarifarioT.containsKey(objTarifarioT.Tarifa__c)){
            	mapTarifarioT.put(objTarifarioT.Tarifa__c, new Map<String, Tarifario_general_terrestre__c>{objTarifarioT.RangoKM__c => objTarifarioT});
            } else if (!mapTarifarioT.get(objTarifarioT.Tarifa__c).containsKey(objTarifarioT.RangoKM__c)){
            	mapTarifarioT.get(objTarifarioT.Tarifa__c).put(objTarifarioT.RangoKM__c, objTarifarioT);
            }
        }
        
        listTarifasExpress = queryTarifarioExpress();
        ObjCostos  = [SELECT EntregaDomicilioZonaPlus__c, SeguroMillarDeclarado__c, IVA__c, EAD__c, RAD__c, CoeficientePV__c, MinEAD__c, MinRAD__c FROM Cotizador__c LIMIT 1];
    	
        //ID DC: a13WA00000U4ilxYAB, ID QA: a134C0000014uXxQAI, ID PROD: a132E000008isbSQAQ
        SBQQ__Quote__c Quote = [SELECT Id, SBQQ__Account__c FROM SBQQ__Quote__c WHERE Id = 'a13WA00000U4ilxYAB'];
        Date fcha = Date.newInstance(2021, 01, 01);
        Date fcha2 = Date.newInstance(2021, 04, 30);
        classDescuento3.getDescuentoRealGMP(Quote.SBQQ__Account__c, Quote.Id, fcha, fcha2, mapTarifarioT, ObjCostos, listTarifasExpress);
    	Test.stopTest();
    }
    
    @IsTest
    static void pruebaDisPot2(){
        Test.startTest();
        Sucursal__c suc = new Sucursal__c();
        suc.Name = 'ver02';
        insert suc;
        
        Principal_destino__c prin = new Principal_destino__c();
        prin.Name = 'prin';
        insert prin;
        
        Id cuentaRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Persona moral').getRecordTypeId();
        Account cuenta = new Account();
        cuenta.Name = 'Cuenta';
        cuenta.RecordTypeId = cuentaRecType;
        cuenta.Id_SIpWeb__c = '';
        cuenta.AccountNumber = '12346';
        cuenta.BillingStreet = 'calle';
        cuenta.BillingState = 'estado';
        cuenta.BillingPostalCode = '9565';
        cuenta.BillingCountry = 'mex';
        //cuenta.Numero_de_facturacion__c = 23.02;
        cuenta.Phone = '2299665544';
        cuenta.FAX_representante_legal__c = '326511132032';
        cuenta.Nombre_notario__c = 'juan';
        cuenta.Nombre_representante_legal__c = 'luis';
        cuenta.N_mero_notaria_Acta__c = '1321';
        cuenta.CURP__c = '161615aa0';   
        cuenta.REGISTRO_P_BLICO_DE_LA_PROPIEDAD_Y_COMER__c = '65461as6';
        cuenta.Sucursal__c = suc.Id;
        cuenta.Potencial_mensual_Total__c = 0;
        cuenta.Potencial_mensual_de_envios__c = 0;
        cuenta.Numero__c = 123;
        cuenta.Colonia__c = 'Colonia';
        cuenta.Piso_envio__c = 'Piso';
        cuenta.Zona_envio__c = 'Zona';
        cuenta.Municipio_Delegaci_n_Sector_facturacion__c = 'Municipio';
        cuenta.Colonia_Facturaci_n__c = 'Colonia Facturacion';
        cuenta.RFC__c = 'OFU111111111';
        cuenta.RazonSocial__c = 'Razon social';
        cuenta.Uso_de_cfdi_CCP__c = 'G03 Gastos en general.';
        cuenta.Regimen_fiscal_CCP__c = '601 General de Ley Personas Morales';
        
        insert cuenta;
        
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = cuenta.id;
        o.CloseDate = System.today().addDays(-183);
        o.StageName = 'Cerrada/Ganada';
        o.Modelo_de_negocios__c = 'B2C';
        insert o;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(
				Acuse__c = 'Empresa',
            	PAQ_TipoServicio__c = 'Estándar terrestre (STD)',
				Modelo_de_tarifas__c = 'Tarifario abierto de piso',
				Servicios_adicionales__c = 'RAD;EAD;EAD Zona plus;Seguro',
				OriginPostalCode__c = '81200',
				SBQQ__ShippingPostalCode__c = '83303',
				OriginCity__c = 'CENTRO',
				SBQQ__ShippingCity__c = 'ALBERTO BUSTAMANTE',
				OriginState__c = 'SINALOA',
				SBQQ__ShippingState__c = 'SONORA',
				Tipo_de_documentacion__c = 'Documentación Remota',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Approved',
            	Tarifas_grabadas_sipweb__c = true,
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = cuenta.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
        
        o.StageName = 'Cerrada/Ganada';
        o.CloseDate = System.today().addDays(-183);
        o.SBQQ__PrimaryQuote__c = quote.Id;
        update o;
        
        //Ventas
        List<String> Tarifas = new List<String>();
        Tarifas.add('TARIFA_TS');
        Tarifas.add('TARIFA_T0');
        Tarifas.add('TARIFA_T1');
        Tarifas.add('TARIFA_T2');
        Tarifas.add('TARIFA_T3');
        Tarifas.add('TARIFA_T4');
        Tarifas.add('TARIFA_T5');
        Tarifas.add('TARIFA_T6');
        Tarifas.add('TARIFA_T7');
        
        List<Ventas__c> iVentas = new List<Ventas__c>();
        for (Integer i = 1; i < 13; i++) { 
            for (String T: Tarifas) {
        		Ventas__c Ven = new Ventas__c();
        		Ven.Cuenta__c = cuenta.Id;
            	Ven.fechaId__c = Date.today().addDays(-100);
            	Ven.OwnerId = UserInfo.getUserId();
            	Ven.totalAntesdeImpuestos__c = 180000;
            	Ven.tipoPago__c = 'REGULAR';
                Ven.origenDoc__c = 'DOCUMLINEA';
            	Ven.cantidad__c = 200;
            	Ven.servicioClave__c = T;
            	Ven.descuento__c = 30;
                
                iVentas.add(Ven);
            }
        } insert iVentas;
        
        Map<Id, List<Opportunity>> oppsByAcc= new Map<Id, List<Opportunity>>();
		oppsByAcc.put(cuenta.Id, new List<Opportunity>());
        oppsByAcc.get(cuenta.Id).add(o);
        
        NotificationDisPot2 BT = new NotificationDisPot2(oppsByAcc);
		Database.executeBatch (BT);
        
        Test.stopTest();
    }
    
    @isTest
    static void testCount(){
        test.startTest();
        classDescuento3.getCount();
        classDescuento3.getCount2();
        test.stopTest();
    }
    
    static List<Tarifario_general_terrestre__c> queryTarifarioTFull(){
        return [SELECT  Id
        , Tarifa__c
        , Flete__c
        , Name
        , PesoMaximo__c
        , VolumenMaximo__c
        , RangoKM__c
        FROM Tarifario_general_terrestre__c WHERE Year__c = null];
    }
    
    static List<Tarifario__c> queryTarifarioExpress(){
        return [SELECT  Id
        , Tarifa__c
        , GuiaDeArranque1Kg__c
        , Kg_adicional__c
        , Rango_km__c
        , year__c
        FROM Tarifario__c WHERE year__c = null];
    }

}