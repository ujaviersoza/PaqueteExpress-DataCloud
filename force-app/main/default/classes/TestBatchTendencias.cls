@Istest()
public class TestBatchTendencias {
    
     @isTest static void validaTendencia(){
        Test.startTest(); 
         	Sucursal__c suc 	= new Sucursal__c ();
            suc.Name			= 'ACA01';
            suc.Id_Sipweb__c	= 'ACA01';
            suc.Plaza__c		= 'ACA';
        	suc.Region_Presupuesto__c = 'CENTRO 1';
        	suc.Zona_Presupuesto__c = 'CS';
        	insert suc;         
            
            //Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
            User 		usr				= AuxTestBatchTendencias.generaUsuario();
            AuxTestBatchTendencias.generaEstructura(usr.Id, suc.Id);
            Account 	acc 			= AuxTestBatchTendencias.generaCuenta();
            AuxTestBatchTendencias.generaVenta(acc.Id, suc.Id, usr.Id);
         	AuxTestBatchTendencias.generaVenta2(acc.Id, suc.Id, usr.Id);
         	AuxTestBatchTendencias.generaVenta3(acc.Id, suc.Id, usr.Id);
            Ano_Calendario__c calendario= AuxTestBatchTendencias.generaCalendario();
            AuxTestBatchTendencias.generaDetalleCalendario(calendario.Id);
            Presupuesto_Comercial__c presupuesto =  AuxTestBatchTendencias.generaPresupuesto();
            AuxTestBatchTendencias.generaDetallePresupuesto(presupuesto.Id, suc.Id);
         	AuxTestBatchTendencias.generaDetallePresupuestoEjecutivo(presupuesto.Id, usr.Id);
                 
            SchedulableContext sc = null;
            CallBatchTendencias x = new CallBatchTendencias();
         
     	
         	x.execute(sc);
            System.enqueueJob(new CallBatchResumenSucursal());
         	System.enqueueJob(new CallBatchResumenSucursalPlaza());
         	System.enqueueJob(new CallBatchResumenSucursalRegion());
         	System.enqueueJob(new CallBatchResumenSucursalZona());
         	System.enqueueJob(new CallBatchResumenSucursalGlobal());
         	
            Database.executeBatch(new Batch_GetInfoSucursales(),1); 
     	Test.stopTest();
     }
}