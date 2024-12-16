@Istest()
public class TestTriggerCuenta {
    
        @isTest static void validaInternacional(){
        Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
     	User 		usr				= AuxTestBatchTendencias.generaUsuario();
        User usrMkt					= AuxTestBatchTendencias.generaUsuarioTMKT();
        //Account cta					= AuxTestBatchTendencias.generaCuenta();
        Presupuesto_Comercial__c p	= AuxTestBatchTendencias.generaPresupuesto();
        
        AuxTestBatchTendencias.generaEstructura(usr.Id, suc.Id);
        
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
        
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.Asignacion_Internacional__c = true;
        acc.AsignacionNacionalRegular__c  = false;
        acc.Sincronizar_con_SW__c = true;
        
        update acc;
         
        AuxTestBatchTendencias.generaVenta(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta2(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta3(acc.Id, suc.Id, usr.Id);
         
        Ano_Calendario__c calendario= AuxTestBatchTendencias.generaCalendario();
        AuxTestBatchTendencias.generaDetalleCalendario(calendario.Id); 
        
        AuxTestBatchTendencias.generaEnlaceEjecutivoCalendario(calendario.Id, usr.Id);
         
        
        
        	 
     	Test.stopTest();
     }
    
     @isTest static void validaNacionalRegularNuevo(){
        Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
     	User 		usr				= AuxTestBatchTendencias.generaUsuario();
        
        AuxTestBatchTendencias.generaEstructura(usr.Id, suc.Id);
         
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
         
        Ventas__c venta = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 200;
        venta.fechaId__c = Date.TODAY()-25;
         
        Ventas__c venta2 = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 200;
        venta.fechaId__c = Date.TODAY()-45;
         
       Ventas__c venta3 = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = -400;
        venta.fechaId__c = Date.TODAY()-75;
         
        insert venta;
        insert venta2;
        insert venta3;
         
        AuxTestBatchTendencias.generaVenta(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta2(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta3(acc.Id, suc.Id, usr.Id);
         
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.AsignacionRegular_Nuevo__c = true;
        acc.AsignacionNacionalRegular__c  = true;
        acc.MigracionPrepagoADocumentacionEnLinea__c = false;
        acc.OmitirValidacionDeInformacion__c = true;
        acc.AsignacionNacionalPrepago__c = true;
        update acc;
        	 
     	Test.stopTest();
     }
    
     @isTest static void validaNacionalRegularNuevo2(){
        Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
     	User 		usr				= AuxTestBatchTendencias.generaUsuario();
        
        AuxTestBatchTendencias.generaEstructura(usr.Id, suc.Id);
         
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
         
        Ventas__c venta = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 200;
        venta.fechaId__c = Date.TODAY();
         
        Ventas__c venta2 = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 200;
        venta.fechaId__c = Date.TODAY()-5;
         
       Ventas__c venta3 = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 200;
        venta.fechaId__c = Date.TODAY()-10;
         
        insert venta;
        insert venta2;
        insert venta3;
         
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.AsignacionRegular_Nuevo__c = true;
        acc.AsignacionNacionalRegular__c  = true;
        acc.MigracionPrepagoADocumentacionEnLinea__c = false;
        acc.OmitirValidacionDeInformacion__c = true;
        acc.AsignacionNacionalPrepago__c = true;
        update acc;
        	 
     	Test.stopTest();
     }
    
     @isTest static void validaNacionalRegularNuevo3(){
        Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
     	User 		usr				= AuxTestBatchTendencias.generaUsuario();
        
        AuxTestBatchTendencias.generaEstructura(usr.Id, suc.Id);
         
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
         
        Ventas__c venta = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 200;
        venta.fechaId__c = Date.TODAY()-25;
         
        Ventas__c venta2 = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 200;
        venta.fechaId__c = Date.TODAY()-45;
         
       Ventas__c venta3 = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 400;
        venta.fechaId__c = Date.TODAY()-75;
         
        insert venta;
        insert venta2;
        insert venta3;
         
        AuxTestBatchTendencias.generaVenta(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta2(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta3(acc.Id, suc.Id, usr.Id);
         
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.AsignacionRegular_Nuevo__c = true;
        acc.AsignacionNacionalRegular__c  = true;
        acc.MigracionPrepagoADocumentacionEnLinea__c = false;
        acc.OmitirValidacionDeInformacion__c = true;
        acc.AsignacionNacionalPrepago__c = true;
        update acc;
         
        TriggerCuenta.getVentaPromedioMensual('TEST ACC', 'OICN9010254P', '87878', acc.Sucursal__r.Plaza__c, acc.Id);
        	 
     	Test.stopTest();
     }
    
    
     @isTest static void validaNacionalRegularRecuperado(){
        Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
     	User 		usr				= AuxTestBatchTendencias.generaUsuario();
        
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Usuario_anterior__c 			= 'TEST_EJECUTIVO';
        acc.Id_SIpWeb__c					= '87878';
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.Modelo_de_negocios__c='B2B'; 
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
         
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.AsignacionRegular_Recuperado__c = true;
        acc.AsignacionNacionalRegular__c  = true;
        acc.MigracionPrepagoADocumentacionEnLinea__c = false;
        acc.OmitirValidacionDeInformacion__c = false;
        acc.AsignacionNacionalPrepago__c = true;
        update acc;
        
        	 
     	Test.stopTest();
     }
    
     @isTest static void validaNacionalRegularMigracion(){
        Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
     	User 		usr				= AuxTestBatchTendencias.generaUsuario();
        
        AuxTestBatchTendencias.generaEstructura(usr.Id, suc.Id);
         
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
         
        Ventas__c venta = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 200;
        venta.fechaId__c = Date.TODAY();
         
        insert venta;
         
        AuxTestBatchTendencias.generaVenta(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta2(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta3(acc.Id, suc.Id, usr.Id);
         
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.AsignacionRegular_Nuevo__c = true;
        acc.AsignacionNacionalRegular__c  = true;
        acc.MigracionPrepagoADocumentacionEnLinea__c = true;
        acc.OmitirValidacionDeInformacion__c = true;
        acc.AsignacionNacionalPrepago__c = false;
        acc.Asignacion_Internacional__c = false;
        
        update acc;
        	 
     	Test.stopTest();
     }
    
     @isTest static void validaNacionalRegularMantenimiento(){
        Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
     	User 		usr				= AuxTestBatchTendencias.generaUsuario();
        
        AuxTestBatchTendencias.generaEstructura(usr.Id, suc.Id);
         
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
         acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
         acc.Cuenta_originada_de_prospecto__c = true;
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
         
        Ventas__c venta = new Ventas__c();
        venta.Cuenta__c = acc.Id;
        venta.cantidad__c = 10;
        venta.totalAntesdeImpuestos__c = 200;
        venta.fechaId__c = Date.TODAY();
         
        insert venta;
         
        AuxTestBatchTendencias.generaVenta(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta2(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta3(acc.Id, suc.Id, usr.Id);
         
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.AsignacionRegular_Mantenimiento__c = true;
        acc.AsignacionNacionalRegular__c  = true;
        acc.MigracionPrepagoADocumentacionEnLinea__c = false;
        acc.OmitirValidacionDeInformacion__c = true;
        acc.AsignacionNacionalPrepago__c = false;
        acc.Asignacion_Internacional__c = false;
        acc.AsignacionNacionalPrepago__c = true;
        
        update acc;
        	 
     	Test.stopTest();
     }
    
    @istest 
    Public Static void testCheckSendforApprovalBeforeUpdateCreditExtension(){
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();   
     	User 		usr				= AuxTestBatchTendencias.generaUsuario();
        
        AuxTestBatchTendencias.generaEstructura(usr.Id, suc.Id);
         
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        acc.Cuenta_originada_de_prospecto__c = true;
        insert acc;
        
        Account 	acc1 			= new Account ();
        acc1.Name 							= 'TEST ACC child  ';
        acc1.Numero__c 						= 1;
        acc1.Colonia__c 						= 'test colonia';
        acc1.Piso_envio__c 					= 'test piso envio';
        acc1.Zona_envio__c 					= 'zona envio';
        acc1.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc1.Potencial_mensual_de_envios__c 	= 1000000;
        acc1.Potencial_mensual_Total__c		= 1000000;
        acc1.ShippingPostalCode				= '01010';
        acc1.BillingPostalCode				= '01010';
        acc1.Sucursal__c						= suc.Id;
        acc1.RFC__c							= 'OICN9010254P';
        acc1.OwnerId							= usr.Id;
        acc1.Usuario_a_asignar__c			= usr.Id;
        acc1.Id_SIpWeb__c					= '87879';
        acc1.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc1.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc1.RazonSocial__c = 'Pruebas';
        acc1.RegimenCapital__c = 'Sociedad anónima de capital variable';
        acc1.Cuenta_originada_de_prospecto__c = true;
        acc1.ParentId = acc.ID;
        insert acc1;
        
        
        Credito__c credito = new Credito__c();
        
        credito.Cuenta__c = acc.Id;
        //credito.RecordType.DeveloperName = 'Alta_de_credito_M';
        credito.Estado__c = 'Nuevo';
        credito.Credito__c = 'N';
        credito.Requiere_dias_o_monto_dif_al_estandar__c = 'No';
        credito.Ingrese_los_d_as_solicitados__c = 7;
        credito.Ingresa_Monto_solicitado__c = 100000;
        
        insert credito;
        
        credito.Estado__c = 'Aprobado';
        update credito;
        
        Credito__c credito2 = new Credito__c();
        
        Id recordTypeCreditExt = Schema.SObjectType.Credito__c.getRecordTypeInfosByDeveloperName().get('Extension_de_credito').getRecordTypeId();
        credito2.Cuenta__c = acc.Id;
        credito2.RecordTypeId = recordTypeCreditExt;//Produccion
        //credito2.RecordTypeId = '0123D000001RhlbQAC';//QA
        credito2.Estado__c = 'Extensión en proceso';
        credito2.Collection_Independent__c = true; //Comentario previo a caso 5.14
      	insert credito2;
                
        acc1.Current_credit_extension__c =  credito2.ID; //Comentario previo a caso 5.14
       
         update acc1;
         //acc1.Current_credit_extension__c = NULL; Comentario previo a caso 5.14
         update acc1;
        Test.stopTest();
         
        
    }
    
    @isTest
    Public Static void TestgetValidacionTareas(){
        
                Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();
        User usrMkt					= AuxTestBatchTendencias.generaUsuarioTMKT();
        Presupuesto_Comercial__c p	= AuxTestBatchTendencias.generaPresupuesto();
        
      
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Administrador del sistema'  OR Name='System Administrator']; 
        User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p1.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser4@testorg.com');
        insert usr;
         
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.AccountId = acc.Id;
        o.OwnerId = usr.Id;
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
        
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.Asignacion_Internacional__c = true;
        acc.AsignacionNacionalRegular__c  = false;
        acc.Sincronizar_con_SW__c = true;
        
        update acc;
     	Test.stopTest();
        
    }
    
    
     @isTest
    Public Static void TestgetValidacionTareas1(){
        
                Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();
        User usrMkt					= AuxTestBatchTendencias.generaUsuarioTMKT();
        Presupuesto_Comercial__c p	= AuxTestBatchTendencias.generaPresupuesto();
        
      
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Administrador del sistema'  OR Name='System Administrator']; 
        User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p1.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser4@testorg.com');
        insert usr;
         
        Account acc1 = new Account();
        acc1.Name = 'Test Parent';
       	acc1.Numero__c = 1;
        acc1.Sucursal__c = suc.Id;

        insert acc1;
        
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        acc.ParentId = acc1.Id;
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.AccountId = acc.Id;
        o.OwnerId = usr.Id;
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
        
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.Asignacion_Internacional__c = true;
        acc.AsignacionNacionalRegular__c  = false;
        acc.Sincronizar_con_SW__c = true;
        
        update acc;
     	Test.stopTest();
        
    }
    @isTest
    Public Static void TestgetValidacionTareas2(){
        
                Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();
        User usrMkt					= AuxTestBatchTendencias.generaUsuarioTMKT();
        Presupuesto_Comercial__c p	= AuxTestBatchTendencias.generaPresupuesto();
        
      
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Administrador del sistema'  OR Name='System Administrator']; 
        User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p1.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser4@testorg.com');
        insert usr;
         
        Account acc1 = new Account();
        acc1.Name = 'Test Parent';
       	acc1.Numero__c = 1;
        acc1.Sucursal__c = suc.Id;

        insert acc1;
        
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        acc.ParentId = acc1.Id;
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        //o.AccountId = acc.Id;
        //o.OwnerId = usr.Id;
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
        
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.Asignacion_Internacional__c = true;
        acc.AsignacionNacionalRegular__c  = false;
        acc.Sincronizar_con_SW__c = true;
        
        update acc;
     	Test.stopTest();
        
    }
    
      @isTest
    Public Static void TestAsignacionEjecutivoNuevo(){
        
                Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        // FAVORITO
        Test.startTest();
     	Sucursal__c suc 			= AuxTestBatchTendencias.generaSucursal();
        
       // User usrMkt					= AuxTestBatchTendencias.generaUsuarioTMKT();
       // Presupuesto_Comercial__c p	= AuxTestBatchTendencias.generaPresupuesto();
        
      
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Administrador del sistema' OR Name='System Administrator']; 
        User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p1.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser4@testorg.com');
        insert usr;
         
        Account acc1 = new Account();
        acc1.Name = 'Test Parent';
       	acc1.Numero__c = 1;
        acc1.Sucursal__c = suc.Id;
        insert acc1;
        
        Account 	acc 			= new Account ();
        acc.Name 							= 'TEST ACC  ';
        acc.Numero__c 						= 1;
        acc.Colonia__c 						= 'test colonia';
        acc.Piso_envio__c 					= 'test piso envio';
        acc.Zona_envio__c 					= 'zona envio';
        acc.Colonia_Facturaci_n__c 			= 'colonia facturacion';
        acc.Potencial_mensual_de_envios__c 	= 1000000;
        acc.Potencial_mensual_Total__c		= 1000000;
        acc.ShippingPostalCode				= '01010';
        acc.BillingPostalCode				= '01010';
        acc.Sucursal__c						= suc.Id;
        acc.RFC__c							= 'OICN9010254P';
        acc.OwnerId							= usr.Id;
        acc.Usuario_a_asignar__c			= usr.Id;
        acc.Id_SIpWeb__c					= '87878';
        
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales. ';
        acc.RazonSocial__c = 'Pruebas';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        acc.ParentId = acc1.Id;
        acc.Preasignar_Ejecutivo__c = false;
        insert acc;
         
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        tsk.WhatId = acc.Id;
        tsk.OwnerId = usr.Id;
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk; 
         
        Opportunity o = new Opportunity();
        o.Name = 'o';
        o.AccountId = acc.id;
        o.CloseDate = system.today();
        o.StageName = 'Oportunidad viable';
        o.AccountId = acc.Id;
        o.OwnerId = usr.Id;
        o.Modelo_de_negocios__c='B2B';
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
				Tipo_de_documentacion__c = 'En Piso-Sipweb',
				TipoCotizacion__c = 'Por convenio',
				SBQQ__Status__c = 'Draft',
				Ingreso_Mensual__c = 512.2966,
				Descuento_Global__c = 0,
				Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = o.Id,
                SBQQ__Primary__c = true
				
		);
        insert quote;
        
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.Asignacion_Internacional__c = true;
        acc.AsignacionNacionalRegular__c  = false;
        acc.Sincronizar_con_SW__c = true;
        acc.Preasignar_Ejecutivo__c = true;
        update acc;
     	Test.stopTest();
        
    }
    @isTest 
    public static void testMigracionConVentasUltimos6Meses() {
        Test.setMock(HttpCalloutMock.class, new CallWS_Rastreo_Test());
        
        Test.startTest();
        
        // Crear datos base
        Sucursal__c suc = AuxTestBatchTendencias.generaSucursal();   
        User usr = AuxTestBatchTendencias.generaUsuario();
        AuxTestBatchTendencias.generaEstructura(usr.Id, suc.Id);
        
        // Crear cuenta principal
        Account acc = new Account();
        acc.Name = 'TEST ACC MIGRACION';
        acc.Numero__c = 1;
        acc.ShippingPostalCode = '01010';
        acc.BillingPostalCode = '01010';
        acc.Sucursal__c = suc.Id;
        acc.RFC__c = 'OICN9010254P';
        acc.OwnerId = usr.Id;
        acc.Usuario_a_asignar__c = usr.Id;
        acc.Id_SIpWeb__c = '87878';
        acc.Regimen_fiscal_CCP__c = '616 Sin obligaciones fiscales';
        acc.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales.';
        acc.RazonSocial__c = 'Pruebas Migracion';
        acc.RegimenCapital__c = 'Sociedad anónima de capital variable';
        insert acc;
        
        // Crear múltiples tareas
        List<Task> tasks = new List<Task>();
        for(Integer i = 0; i < 5; i++) {
            Task tsk = new Task(
                Subject = 'Test Task ' + i,
                WhatId = acc.Id,
                OwnerId = usr.Id,
                Status = 'Completed',
                ActivityDate = Date.today().addDays(-i),
                Type = 'Call'
            );
            tasks.add(tsk);
        }
        insert tasks;
        
        // Crear eventos
        Event evt = new Event(
            Subject = 'Test Event',
            WhatId = acc.Id,
            OwnerId = usr.Id,
            StartDateTime = DateTime.now(),
            EndDateTime = DateTime.now().addHours(1),
            Type = 'Meeting'
        );
        insert evt;
        
        // Crear múltiples oportunidades
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < 3; i++) {
            Opportunity opp = new Opportunity(
                Name = 'Test Opp ' + i,
                AccountId = acc.Id,
                CloseDate = System.today().addMonths(1),
                StageName = 'Cerrada/Ganada',
                OwnerId = usr.Id,
                Modelo_de_negocios__c = 'B2B'
            );
            opps.add(opp);
        }
        insert opps;
        
        // Crear múltiples cotizaciones
        List<SBQQ__Quote__c> quotes = new List<SBQQ__Quote__c>();
        for(Opportunity opp : opps) {
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
                Tipo_de_documentacion__c = 'En Piso-Sipweb',
                TipoCotizacion__c = 'Por convenio',
                SBQQ__Status__c = 'Draft',
                Ingreso_Mensual__c = 5000,
                Descuento_Global__c = 0,
                Paquetes_Mensuales__c = 200,
                SBQQ__Account__c = acc.Id,
                SBQQ__Opportunity2__c = opp.Id,
                SBQQ__Primary__c = true
            );
            quotes.add(quote);
        }
        insert quotes;
        
        // Generar ventas usando el helper
        AuxTestBatchTendencias.generaVenta(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta2(acc.Id, suc.Id, usr.Id);
        AuxTestBatchTendencias.generaVenta3(acc.Id, suc.Id, usr.Id);
        
        // Primera configuración: asegurarse que todas las validaciones pasen
        acc.Ficha_t_cnica_y_convenio_de_servicios__c = 'TEST';
        acc.AsignarEjecutivoACuentaEnSipweb__c = true;
        acc.AsignacionRegular_Nuevo__c = true;
        acc.AsignacionNacionalRegular__c = true;
        acc.MigracionPrepagoADocumentacionEnLinea__c = true;
        acc.OmitirValidacionDeInformacion__c = true;
        update acc;
        
        // Primera llamada al método
        TriggerCuenta.ValidaAsignacionEjecutivoMigracion(
            acc.Name.substring(0, Math.min(acc.Name.length(), 10)),
            acc.RFC__c,
            acc.Id_SIpWeb__c,
            suc.Plaza__c,
            acc.Id
        );
        
        // Segunda configuración con OmitirValidacionDeInformacion = false
        acc.OmitirValidacionDeInformacion__c = false;
        update acc;
        
        // Segunda llamada al método
        TriggerCuenta.ValidaAsignacionEjecutivoMigracion(
            acc.Name.substring(0, Math.min(acc.Name.length(), 10)),
            acc.RFC__c,
            acc.Id_SIpWeb__c,
            suc.Plaza__c,
            acc.Id
        );
        
        // Verificar resultados
        Account accUpdated = [SELECT Id, 
                             ALERTA_Revisa_su_Venta_existente__c,
                             ValidacionMigracion__c,
                             Validacion_Migracion_GERENTE_KAM__c,
                             Validacion_Migracion_GERENTE_KAM_AUX__c
                             FROM Account 
                             WHERE Id = :acc.Id];
        
        System.assertNotEquals(null, accUpdated.ValidacionMigracion__c, 
                             'La validación de migración no debería ser nula');
        
        Test.stopTest();
    }
}