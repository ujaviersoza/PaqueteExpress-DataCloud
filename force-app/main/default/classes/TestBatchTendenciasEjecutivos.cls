@Istest()
public class TestBatchTendenciasEjecutivos {
    
     @isTest static void validaTendencia(){
        Test.startTest();
        // SUCURSAL
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
     	User 		usr				= AuxTestBatchTendencias.generaUsuario();
        Account 	acc 			= AuxTestBatchTendencias.generaCuenta();
        Ano_Calendario__c calendario= AuxTestBatchTendencias.generaCalendario();
        AuxTestBatchTendencias.generaDetalleCalendario(calendario.Id);
        Presupuesto_Comercial__c presupuesto =  AuxTestBatchTendencias.generaPresupuesto();
        
        // EJECUTIVO
        AuxTestBatchTendencias.generaEnlaceEjecutivoCalendario(calendario.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta2(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta3(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaDetallePresupuestoEjecutivo(presupuesto.Id, usr.Id);
         
        System.debug('USUARIO ID: ' + usr.Id);
        System.debug('USUARIO PLAZA: '+ usr.Plaza__c);
        System.debug('USUARIO ZONA: ' + usr.Zona__c);
        System.debug('USUARIO REGION: ' + usr.Region__c);
     
        SchedulableContext sc2 = null;
        CallBatchTendenciasEjecutivos x2 = new CallBatchTendenciasEjecutivos();
         
     	
         	//x.execute(sc);
         	x2.execute(sc2);
         	System.enqueueJob(new CallBatchResumenTendenciaEjecutivos());
         	System.enqueueJob(new CallBatchResumenEjecutivoPlaza());
         	System.enqueueJob(new CallBatchResumenEjecutivoRegion());
         	System.enqueueJob(new CallBatchResumenEjecutivoZona());
         	System.enqueueJob(new CallBatchResumenEjecutivoGlobal());
     	Test.stopTest();
     }
}