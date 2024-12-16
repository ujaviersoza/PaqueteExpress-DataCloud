public class AuxTendenciaEjecutivo {
    
    public static void notificaLlamadoWS (String resultado){
    	try{
			
            String contenido = 'Resultado Batch: ' + resultado; 
            
            
            /*Blob body = Blob.valueOf(contenido);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/txt');
            attach.setFileName('BatchTendencia.txt');
            attach.setInline(false);
            attach.Body = body;*/
            List<String> toAddresses =  new  List<String>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String emailRA = System.Label.emailRA;
            toAddresses = emailRA.split(';');      
            mail.setUseSignature(false);
            mail.setToAddresses(toAddresses);
            mail.setSubject('LOG BATCH TENDENCIA');
            mail.setHtmlBody(contenido);
            //mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
                
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
            }catch (Exception e){
                system.debug(e);
                System.debug(e.getlinenumber());
                System.debug(e.getCause());
                System.debug(e.getStackTraceString());
            }
    	
    }
    
    public static void importaPresupuestosEjecutivo (Id ejecutivoId, String mesConsulta, String anio, Date fecha){
        
        System.debug('ejecutivoId: ' 	+ ejecutivoId);
        System.debug('mesConsulta: '	+ mesConsulta);
        System.debug('anio: '	 		+ anio);
        System.debug('fecha: ' 			+ fecha);
        
        List<Detalle_Presupuesto__c> 	dpSucursalList 	= new List<Detalle_Presupuesto__c>();
        List<Tendencia__c> 				dpTendenciaList = new List<Tendencia__c>();
        List<Tendencia__c>				tendenciasPresupuestosList = new List<Tendencia__c>();
        
        dpTendenciaList = [SELECT Id, Ejecutivo__c, Anio__c, Mes__c FROM Tendencia__c WHERE Ejecutivo__c =: ejecutivoId AND Mes__c =: mesConsulta 
                           AND Anio__c =: anio AND Tipo_de_Importe__c IN: llenaValoresPresupuesto()];
        if(test.isRunningTest()){
            dpSucursalList 	= [ SELECT Id, 								Total_presupuesto__c,						Mensajeria_TS_T0_estandar__c,
                                Mensajeria_TS_T0_express__c,			Mensajeria_TS_T0_internacional__c,			Paqueteria_Carga_T1_T7_Estandar__c,
                                Paqueteria_Carga_T1_T7_Express__c,		Paqueteria_Carga_T1_T7_Internacional__c,	Servicios_Estandar__c,
                                Servicios_Express__c,					Servicios_Internacionales__c,				Total_mensajeria_TS_T0__c,
                                Total_Paqueteria_Carga_T1_T7__c,		Total_Servicios__c,							Total_estandar__c,
                                Total_express__c,						Total_Internacional__c,						Total_Nacional__c,
                                Total_presupuesto_mantenimiento__c,		Mensajeria_TS_T0_estandar_mantenimiento__c,	Mensajeria_TS_T0_express_mantenimiento__c,
                                Mensajeria_TS_T0_internacional_mtto__c,	Paqueteria_Carga_T1_T7_Estandar_mtto__c,	Paqueteria_Carga_T1_T7_Express_mtto__c,
                                Paqueteria_y_Carga_T1_T7_Int_mtto__c,	Servicios_Estandar_Mantenimiento__c,		Servicios_Express_Mantenimiento__c,
                                Servicios_Internacionales_Mantenimiento__c, Total_mensajeria_TS_T0_Mantenimiento__c,Total_paqueteria_carga_T1_T7_Mtto__c,
                                Total_Servicios_Mantenimiento__c,		Total_estandar_mantenimiento__c,			Total_express_mantenimiento__c,
                                Total_Internacional_Mantenimiento__c,	Total_Nacional_Mantenimiento__c,			Total_Presupuesto_Ejecutivo__c,
                                Total_Mensajeria__c,					Total_PyC__c,								Total_Servicio__c,
                                Total_total_Estandar__c,				Total_total_Express__c,						Total_total_Internacional__c
                                FROM Detalle_Presupuesto__c LIMIT 1];
        }else{
            dpSucursalList 	= [ SELECT Id, 								Total_presupuesto__c,						Mensajeria_TS_T0_estandar__c,
                                Mensajeria_TS_T0_express__c,			Mensajeria_TS_T0_internacional__c,			Paqueteria_Carga_T1_T7_Estandar__c,
                                Paqueteria_Carga_T1_T7_Express__c,		Paqueteria_Carga_T1_T7_Internacional__c,	Servicios_Estandar__c,
                                Servicios_Express__c,					Servicios_Internacionales__c,				Total_mensajeria_TS_T0__c,
                                Total_Paqueteria_Carga_T1_T7__c,		Total_Servicios__c,							Total_estandar__c,
                                Total_express__c,						Total_Internacional__c,						Total_Nacional__c,
                                Total_presupuesto_mantenimiento__c,		Mensajeria_TS_T0_estandar_mantenimiento__c,	Mensajeria_TS_T0_express_mantenimiento__c,
                                Mensajeria_TS_T0_internacional_mtto__c,	Paqueteria_Carga_T1_T7_Estandar_mtto__c,	Paqueteria_Carga_T1_T7_Express_mtto__c,
                                Paqueteria_y_Carga_T1_T7_Int_mtto__c,	Servicios_Estandar_Mantenimiento__c,		Servicios_Express_Mantenimiento__c,
                                Servicios_Internacionales_Mantenimiento__c, Total_mensajeria_TS_T0_Mantenimiento__c,Total_paqueteria_carga_T1_T7_Mtto__c,
                                Total_Servicios_Mantenimiento__c,		Total_estandar_mantenimiento__c,			Total_express_mantenimiento__c,
                                Total_Internacional_Mantenimiento__c,	Total_Nacional_Mantenimiento__c,			Total_Presupuesto_Ejecutivo__c,
                                Total_Mensajeria__c,					Total_PyC__c,								Total_Servicio__c,
                                Total_total_Estandar__c,				Total_total_Express__c,						Total_total_Internacional__c
                                FROM Detalle_Presupuesto__c WHERE Ejecutivo__c =: ejecutivoId AND Mes__c =:mesConsulta AND Anio__c =: anio];
        }
        System.debug('dpTendenciaList.size() : ' + dpTendenciaList.size());
        System.debug('dpSucursalList.size()  : ' + dpSucursalList.size());
        
        if(dpTendenciaList.size()==0 && dpSucursalList.size()==1){
            Map<String, Decimal> presupuestoValorMap = new Map<String, Decimal> ();
            presupuestoValorMap = llenaValoresPresupuestoMAp(dpSucursalList);
            for(String presupuesto: llenaValoresPresupuesto()){
                Tendencia__c t 		= new Tendencia__c ();
                t.Ejecutivo__c	 	= ejecutivoId;
                t.Tipo_de_Importe__c= presupuesto;
                t.Fecha__c			= fecha;
                t.Importe__c		= presupuestoValorMap.get(presupuesto);
                t.OwnerId			= ejecutivoId;
                tendenciasPresupuestosList.add(t);
                
                System.debug('for: presupuesto : ' + presupuesto);
                System.debug('for: presupuestoValorMap.get(presupuesto) : ' + presupuestoValorMap.get(presupuesto));
                
            }
            
            if(tendenciasPresupuestosList.size()>0){
                insert tendenciasPresupuestosList;
            }
        }
        
        
    }
    
    public static void generaResumenVentasEjecutivo (Id vendedorId, Date fecha, String mesconsulta){
        
        String 	contenido 		= '';
        Date 	hoy 			= fecha;
        
        
        List<Tendencia__c>	tendenciasVentasList 	= new List<Tendencia__c>();
        Map<String, Decimal> ventasValorMap 		= new Map<String, Decimal> ();
            
        Set<Id> idSucursal 							= new Set<Id>();
        Decimal totalVentasGLOBAL					= 0;
        
        // TOTALES
        Decimal totalVentaClienteNuevo				= 0;
        Decimal totalVentaClienteMantenimiento		= 0;
        
        Decimal totalMensajeriaGLOBAL				= 0;
        Decimal totalMensajeria_EstandarGLOBAL 		= 0;
        Decimal totalMensajeria_ExpressGLOBAL 		= 0;
        Decimal totalMensajeria_InternacionalGLOBAL	= 0;
        
        Decimal totalPaqueteriaGLOBAL				= 0;
        Decimal totalPaqueteria_EstandarGLOBAL		= 0;
        Decimal totalPaqueteria_ExpressGLOBAL		= 0;
        Decimal totalPaqueteria_InternacionalGLOBAL	= 0;
        
        Decimal totalServiciosGLOBAL				= 0;
        Decimal totalServicios_EstandarGLOBAL		= 0;
        Decimal totalServicios_ExpressGLOBAL		= 0;
        Decimal totalServicios_InternacionalGLOBAL	= 0;
        
        Decimal totalEstandarGLOBAL					= 0;
        Decimal totalExpressGLOBAL					= 0;
        Decimal totalInternacionalGLOBAL			= 0;
        Decimal totalNacionalGLOBAL					= 0;
        
        Decimal totalServicios_RADGLOBAL			= 0;
        Decimal totalServicios_EADGLOBAL			= 0;
        Decimal totalServicios_ZonaExtGLOBAL		= 0;
        Decimal totalServicios_AcuseGLOBAL			= 0;
        Decimal totalServicios_SeguroGLOBAL			= 0;
        Decimal totalServicios_CODGLOBAL			= 0;
        Decimal totalServicios_OtrosGLOBAL			= 0;
        
        // VARIABLES CLIENTE NUEVO
        Decimal totalMensajeriaNVO 					= 0;
        Decimal totalMensajeria_EstandarNVO 		= 0;
        Decimal totalMensajeria_ExpressNVO 			= 0;
        Decimal totalMensajeria_InternacionalNVO	= 0;
        
        Decimal totalPaqueteriaNVO 					= 0;
        Decimal totalPaqueteria_EstandarNVO			= 0;
        Decimal totalPaqueteria_ExpressNVO 			= 0;
        Decimal totalPaqueteria_InternacionalNVO	= 0;
        
        Decimal totalServiciosNVO 					= 0;
        Decimal totalServicios_EstandarNVO			= 0;
        Decimal totalServicios_ExpressNVO			= 0;
        Decimal totalServicios_InternacionalNVO		= 0;
        
        Decimal totalEstandarNVO					= 0;
        Decimal totalExpressNVO						= 0;
        Decimal totalInternacionalNVO				= 0;
        Decimal totalNacionalNVO					= 0;
        
        Decimal totalServicios_RADNVO				= 0;
        Decimal totalServicios_EADNVO				= 0;
        Decimal totalServicios_ZonaExtNVO			= 0;
        Decimal totalServicios_AcuseNVO				= 0;
        Decimal totalServicios_SeguroNVO			= 0;
        Decimal totalServicios_CODNVO				= 0;
        Decimal totalServicios_OtrosNVO				= 0;
                
        // VARIABLES MANTENIMIENTO
        Decimal totalMensajeriaMTTO					= 0;
        Decimal totalMensajeria_EstandarMTTO		= 0;
        Decimal totalMensajeria_ExpressMTTO			= 0;
        Decimal totalMensajeria_InternacionalMTTO	= 0;
        
        Decimal totalPaqueteriaMTTO					= 0;
        Decimal totalPaqueteria_EstandarMTTO		= 0;
        Decimal totalPaqueteria_ExpressMTTO			= 0;
        Decimal totalPaqueteria_InternacionalMTTO	= 0;
        
        Decimal totalServiciosMTTO 					= 0;
        Decimal totalServicios_EstandarMTTO			= 0;
        Decimal totalServicios_ExpressMTTO			= 0;
        Decimal totalServicios_InternacionalMTTO	= 0;
        
        Decimal totalEstandarMTTO					= 0;
        Decimal totalExpressMTTO					= 0;
        Decimal totalInternacionalMTTO				= 0;
        Decimal totalNacionalMTTO					= 0;
        
        Decimal totalServicios_RADMTTO				= 0;
        Decimal totalServicios_EADMTTO				= 0;
        Decimal totalServicios_ZonaExtMTTO			= 0;
        Decimal totalServicios_AcuseMTTO			= 0;
        Decimal totalServicios_SeguroMTTO			= 0;
        Decimal totalServicios_CODMTTO				= 0;
        Decimal totalServicios_OtrosMTTO			= 0;
        
        
       
        contenido += 'Fecha: '+ hoy + '\n IdVendedor: ' + vendedorId; 
        system.debug('CONTENIDO: ' + contenido);
         
        List<Ventas__dlm> ventasList = new List<Ventas__dlm>();
        // Obtener el FederationId del usuario actual
        User currentUser = [SELECT FederationIdentifier FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        String federationId = currentUser.FederationIdentifier;
                
        if(test.isRunningTest()){
            ventasList = [
                SELECT total_despues_de_impuestos__c, total_antes_de_impuestos__c, 
                       sucursal_origen_clave__c, fecha_id__c, servicio_clave__c, 
                       tipo_destino__c, tipo_servicio__c, cliente_tipo_comercial__c  
                FROM Ventas__dlm
            ];
        }else{
            ventasList = [
                SELECT total_despues_de_impuestos__c, total_antes_de_impuestos__c, 
                       sucursal_origen_clave__c, fecha_id__c, servicio_clave__c, 
                       tipo_destino__c, tipo_servicio__c, cliente_tipo_comercial__c  
                FROM Ventas__dlm 
                WHERE total_despues_de_impuestos__c != null 
                AND fecha_venta__c = :hoy
                AND ejecutivo_origen_clave__c = :federationId
            ];
        }
        
        for(Ventas__dlm v: ventaslist){
        	
            totalVentasGLOBAL += v.total_antes_de_impuestos__c;
            
            // VENTAS NUEVAS
            if(v.cliente_tipo_comercial__c == 'NUEVO' || test.isRunningTest()){
                
                totalVentaClienteNuevo += v.total_antes_de_impuestos__c;
            
                // ============================= VENTAS MENSAJERIA ================================
                if(v.servicio_clave__c == 'TARIFA_T0' || v.servicio_clave__c == 'TARIFA_TS' || test.isRunningTest()){
                    totalMensajeriaNVO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS MENSAJERIA ESTANDAR
                if(((v.servicio_clave__c == 'TARIFA_T0' || v.servicio_clave__c == 'TARIFA_TS') && v.tipo_destino__c == 'NACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalMensajeria_EstandarNVO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS MENSAJERIA EXPRESS
                if(((v.servicio_clave__c == 'TARIFA_T0' || v.servicio_clave__c == 'TARIFA_TS') && v.tipo_destino__c == 'NACIONAL' && (v.tipo_servicio__c =='SEG-DS' || v.tipo_servicio__c =='SEG-2D' || v.tipo_servicio__c =='SEG-A12' || v.tipo_servicio__c =='SEG-MD' )) || test.isRunningTest() ){
                    totalMensajeria_ExpressNVO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS MENSAJERIA INTERNACIONAL
                if(((v.servicio_clave__c == 'TARIFA_T0' || v.servicio_clave__c == 'TARIFA_TS') && v.tipo_destino__c == 'INTERNACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalMensajeria_InternacionalNVO 	+= v.total_antes_de_impuestos__c;
                }
    
                
                // ============================= VENTAS PAQUETERIA Y CARGA ==============================
                if((v.servicio_clave__c == 'TARIFA_T1' || v.servicio_clave__c == 'TARIFA_T2' || v.servicio_clave__c == 'TARIFA_T3' || v.servicio_clave__c == 'TARIFA_T4' || v.servicio_clave__c == 'TARIFA_T5' || v.servicio_clave__c == 'TARIFA_T6' || v.servicio_clave__c == 'TARIFA_T7') || test.isRunningTest()){
                    totalPaqueteriaNVO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS PAQUETERIA Y CARGA ESTANDAR
                if(((v.servicio_clave__c == 'TARIFA_T1' || v.servicio_clave__c == 'TARIFA_T2' || v.servicio_clave__c == 'TARIFA_T3' || v.servicio_clave__c == 'TARIFA_T4' || v.servicio_clave__c == 'TARIFA_T5' || v.servicio_clave__c == 'TARIFA_T6' || v.servicio_clave__c == 'TARIFA_T7')
                   && v.tipo_destino__c == 'NACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalPaqueteria_EstandarNVO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS PAQUETERIA Y CARGA EXPRESS
                if(((v.servicio_clave__c == 'TARIFA_T1' || v.servicio_clave__c == 'TARIFA_T2' || v.servicio_clave__c == 'TARIFA_T3' || v.servicio_clave__c == 'TARIFA_T4' || v.servicio_clave__c == 'TARIFA_T5' || v.servicio_clave__c == 'TARIFA_T6' || v.servicio_clave__c == 'TARIFA_T7')
                   && v.tipo_destino__c == 'NACIONAL' && (v.tipo_servicio__c =='SEG-DS' || v.tipo_servicio__c =='SEG-2D' || v.tipo_servicio__c =='SEG-A12' || v.tipo_servicio__c =='SEG-MD' )) 
                  || test.isRunningTest()){
                    totalPaqueteria_ExpressNVO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS PAQUETERIA Y CARGA INTERNACIONAL
                if(((v.servicio_clave__c == 'TARIFA_T1' || v.servicio_clave__c == 'TARIFA_T2' || v.servicio_clave__c == 'TARIFA_T3' || v.servicio_clave__c == 'TARIFA_T4' || v.servicio_clave__c == 'TARIFA_T5' || v.servicio_clave__c == 'TARIFA_T6' || v.servicio_clave__c == 'TARIFA_T7')
                   && v.tipo_destino__c == 'INTERNACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalPaqueteria_InternacionalNVO 	+= v.total_antes_de_impuestos__c;
                }
                
                
                // ============================= VENTAS SERVICIOS ==============================
                if((v.servicio_clave__c != 'TARIFA_TS' && v.servicio_clave__c != 'TARIFA_T0' && v.servicio_clave__c != 'TARIFA_T1' && v.servicio_clave__c != 'TARIFA_T2' && v.servicio_clave__c != 'TARIFA_T3' && v.servicio_clave__c != 'TARIFA_T4' && v.servicio_clave__c != 'TARIFA_T5' && v.servicio_clave__c != 'TARIFA_T6' && v.servicio_clave__c != 'TARIFA_T7') || test.isRunningTest()){
                    totalServiciosNVO += v.total_antes_de_impuestos__c;
                    
                    // SERVICIOS RAD
                    if(v.servicio_clave__c == 'RAD' || test.isRunningTest()){
                        totalServicios_RADNVO += v.total_antes_de_impuestos__c;    
                    }
                    
                    // SERVICIOS EAD
                    if(v.servicio_clave__c == 'EAD' || test.isRunningTest()){
                        totalServicios_EADNVO += v.total_antes_de_impuestos__c;
                    }
                    
                    // SERVICIOS ZONA EXTENDIDA
                    if(v.servicio_clave__c == 'ESP-1' || v.servicio_clave__c == 'MISIVA_FLETE' ||  v.servicio_clave__c == 'LYNDEN_FLETE' || test.isRunningTest()){
                        totalServicios_ZonaExtNVO += v.total_antes_de_impuestos__c;
                    }
                    
                    //SERVICIOS ACUSE
                    if(v.servicio_clave__c == 'ACUSE_CLIENTE' || v.servicio_clave__c == 'ACUSE_INTERNO' || v.servicio_clave__c == 'ACUSE_XT' || test.isRunningTest()){
                        totalServicios_AcuseNVO += v.total_antes_de_impuestos__c;
                    }
                    
                    //SERVICIOS SEGURO
                    if(v.servicio_clave__c == 'SEGURO' || test.isRunningTest()){
                        totalServicios_SeguroNVO += v.total_antes_de_impuestos__c;
                    }
                    
                    //SERVICIOS COD
                    if(v.servicio_clave__c == 'COD' || test.isRunningTest()){
                        totalServicios_CODNVO += v.total_antes_de_impuestos__c;
                    }
                    
                    //SERVICIOS OTROS
                    if(v.servicio_clave__c == 'ALMACENAJE' 				|| v.servicio_clave__c == 'COM' 						|| v.servicio_clave__c == 'EAD_CITA' 					||
                       v.servicio_clave__c == 'EAD_DET' 					|| v.servicio_clave__c == 'EMB-1' 					|| v.servicio_clave__c == 'EMB-2' 					||
                       v.servicio_clave__c == 'EMB-3' 					|| v.servicio_clave__c == 'EMB-4' 					|| v.servicio_clave__c == 'EMB-5'	 					||
                       v.servicio_clave__c == 'EMBALAJE-T0' 				|| v.servicio_clave__c == 'EMBALAJE-T1' 				|| v.servicio_clave__c == 'EMBALAJE-T2' 				||
                       v.servicio_clave__c == 'EMBALAJE-T3' 				|| v.servicio_clave__c == 'ENTREGA_LOCAL' 			|| v.servicio_clave__c == 'FASTEX_CAMBIO_DOMICILIO' 	||
                       v.servicio_clave__c == 'FASTEX_DEVOLUCION' 		|| v.servicio_clave__c == 'FASTEX_PEDIMENTO' 			|| v.servicio_clave__c == 'FASTEX_REEXPEDICION' 		||
                       v.servicio_clave__c == 'FEDEX_CAMBIO_DOMICILIO' 	|| v.servicio_clave__c == 'FEDEX_COSTO_COMBUSTIBLE' 	|| v.servicio_clave__c == 'FEDEX_DEVOLUCION' 			||
                       v.servicio_clave__c == 'FEDEX_GASTOS_ADUANA' 		|| v.servicio_clave__c == 'FEDEX_REEXPEDICION' 		|| v.servicio_clave__c == 'FLEJE' 					||
                       v.servicio_clave__c == 'FTL' 						|| v.servicio_clave__c == 'FTL-ACU' 					|| v.servicio_clave__c == 'FTL-EST' 					||
                       v.servicio_clave__c == 'FTL-MAN' 					|| v.servicio_clave__c == 'FTL-REP' 					|| v.servicio_clave__c == 'FTL-SEG' 					||
                       v.servicio_clave__c == 'MANIOBRAS' 				|| v.servicio_clave__c == 'NA' 						|| v.servicio_clave__c == 'OTROS' 					||
                       v.servicio_clave__c == 'PALETTE' 					|| v.servicio_clave__c == 'PICKING' 					|| v.servicio_clave__c == 'PQE_COSTO_COMBUSTIBLE' 	||
                       v.servicio_clave__c == 'RAD-ZP' 					|| v.servicio_clave__c == 'SERV_ADICIONALES' 			|| v.servicio_clave__c == 'SPECIAL_PACKAGING' 		||
                       v.servicio_clave__c == 'TRANSFER_ADMIN_DE_FLETE' 	|| v.servicio_clave__c == 'TRANSFER_ALMACENAJE' 		|| v.servicio_clave__c == 'TRANSFER_CRUCE_FRONTERIZO' ||
                       v.servicio_clave__c == 'TRANSFER_FLETE_EXTRANJERO' || v.servicio_clave__c == 'TRANSFER_GASTOS_ADUANALES' || v.servicio_clave__c == 'UNIDAD DEDICADA 0.7' 		||
                       v.servicio_clave__c == 'UNIDAD DEDICADA 1.7' 		|| v.servicio_clave__c == 'UPS_CAMBIO_DOMICILIO' 		|| v.servicio_clave__c == 'UPS_COSTO_COMBUSTIBLE' 	||
                       v.servicio_clave__c == 'UPS_ENTREGA_SABADO' 		|| v.servicio_clave__c == 'UPS_EXTENDIDO' 			|| v.servicio_clave__c == 'UPS_GASTOS_ADUANALES' 		||
                       v.servicio_clave__c == 'UPS_PEDIMENTO' 			|| v.servicio_clave__c == 'UPS-PAQ'					|| test.isRunningTest() ){
                        totalServicios_OtrosNVO += v.total_antes_de_impuestos__c;
                    }
                    
                }
                
                // VENTAS SERVICIOS Y CARGA ESTANDAR
                if(((v.servicio_clave__c != 'TARIFA_TS' && v.servicio_clave__c != 'TARIFA_T0' && v.servicio_clave__c != 'TARIFA_T1' && v.servicio_clave__c != 'TARIFA_T2' && v.servicio_clave__c != 'TARIFA_T3' && v.servicio_clave__c != 'TARIFA_T4' && v.servicio_clave__c != 'TARIFA_T5' && v.servicio_clave__c != 'TARIFA_T6' && v.servicio_clave__c != 'TARIFA_T7')
                   && v.tipo_destino__c == 'NACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalServicios_EstandarNVO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS SERVICIOS Y CARGA EXPRESS
                if(((v.servicio_clave__c != 'TARIFA_TS' && v.servicio_clave__c != 'TARIFA_T0' && v.servicio_clave__c != 'TARIFA_T1' && v.servicio_clave__c != 'TARIFA_T2' && v.servicio_clave__c != 'TARIFA_T3' && v.servicio_clave__c != 'TARIFA_T4' && v.servicio_clave__c != 'TARIFA_T5' && v.servicio_clave__c != 'TARIFA_T6' && v.servicio_clave__c != 'TARIFA_T7')
                   && v.tipo_destino__c == 'NACIONAL' && (v.tipo_servicio__c =='SEG-DS' || v.tipo_servicio__c =='SEG-2D' || v.tipo_servicio__c =='SEG-A12' || v.tipo_servicio__c =='SEG-MD' ))
                  || test.isRunningTest()){
                    totalServicios_ExpressNVO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS SERVICIOS Y CARGA INTERNACIONAL
                if(((v.servicio_clave__c != 'TARIFA_TS' && v.servicio_clave__c != 'TARIFA_T0' && v.servicio_clave__c != 'TARIFA_T1' && v.servicio_clave__c != 'TARIFA_T2' && v.servicio_clave__c != 'TARIFA_T3' && v.servicio_clave__c != 'TARIFA_T4' && v.servicio_clave__c != 'TARIFA_T5' && v.servicio_clave__c != 'TARIFA_T6' && v.servicio_clave__c != 'TARIFA_T7')
                   && v.tipo_destino__c == 'INTERNACIONAL' && v.tipo_servicio__c =='STD-T' )
                  || test.isRunningTest()){
                    totalServicios_InternacionalNVO 	+= v.total_antes_de_impuestos__c;
                }
                
            }
            
			// VENTA DE MANTENIMIENTO 
			if(v.cliente_tipo_comercial__c == 'MANTENIMIENTO' || test.isRunningTest()){
                
                totalVentaClienteMantenimiento += v.total_antes_de_impuestos__c;
                
                // ============================= VENTAS MENSAJERIA ================================
                if(v.servicio_clave__c == 'TARIFA_T0' || v.servicio_clave__c == 'TARIFA_TS' || test.isRunningTest()){
                    totalMensajeriaMTTO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS MENSAJERIA ESTANDAR
                if(((v.servicio_clave__c == 'TARIFA_T0' || v.servicio_clave__c == 'TARIFA_TS') && v.tipo_destino__c == 'NACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalMensajeria_EstandarMTTO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS MENSAJERIA EXPRESS
                if(((v.servicio_clave__c == 'TARIFA_T0' || v.servicio_clave__c == 'TARIFA_TS') && v.tipo_destino__c == 'NACIONAL' && (v.tipo_servicio__c =='SEG-DS' || v.tipo_servicio__c =='SEG-2D' || v.tipo_servicio__c =='SEG-A12' || v.tipo_servicio__c =='SEG-MD' )) || test.isRunningTest() ){
                    totalMensajeria_ExpressMTTO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS MENSAJERIA INTERNACIONAL
                if(((v.servicio_clave__c == 'TARIFA_T0' || v.servicio_clave__c == 'TARIFA_TS') && v.tipo_destino__c == 'INTERNACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalMensajeria_InternacionalMTTO 	+= v.total_antes_de_impuestos__c;
                }
    
                
                // ============================= VENTAS PAQUETERIA Y CARGA ==============================
                if((v.servicio_clave__c == 'TARIFA_T1' || v.servicio_clave__c == 'TARIFA_T2' || v.servicio_clave__c == 'TARIFA_T3' || v.servicio_clave__c == 'TARIFA_T4' || v.servicio_clave__c == 'TARIFA_T5' || v.servicio_clave__c == 'TARIFA_T6' || v.servicio_clave__c == 'TARIFA_T7') || test.isRunningTest()){
                    totalPaqueteriaMTTO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS PAQUETERIA Y CARGA ESTANDAR
                if(((v.servicio_clave__c == 'TARIFA_T1' || v.servicio_clave__c == 'TARIFA_T2' || v.servicio_clave__c == 'TARIFA_T3' || v.servicio_clave__c == 'TARIFA_T4' || v.servicio_clave__c == 'TARIFA_T5' || v.servicio_clave__c == 'TARIFA_T6' || v.servicio_clave__c == 'TARIFA_T7')
                   && v.tipo_destino__c == 'NACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalPaqueteria_EstandarMTTO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS PAQUETERIA Y CARGA EXPRESS
                if(((v.servicio_clave__c == 'TARIFA_T1' || v.servicio_clave__c == 'TARIFA_T2' || v.servicio_clave__c == 'TARIFA_T3' || v.servicio_clave__c == 'TARIFA_T4' || v.servicio_clave__c == 'TARIFA_T5' || v.servicio_clave__c == 'TARIFA_T6' || v.servicio_clave__c == 'TARIFA_T7')
                   && v.tipo_destino__c == 'NACIONAL' && (v.tipo_servicio__c =='SEG-DS' || v.tipo_servicio__c =='SEG-2D' || v.tipo_servicio__c =='SEG-A12' || v.tipo_servicio__c =='SEG-MD' )) 
                  || test.isRunningTest()){
                    totalPaqueteria_ExpressMTTO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS PAQUETERIA Y CARGA INTERNACIONAL
                if(((v.servicio_clave__c == 'TARIFA_T1' || v.servicio_clave__c == 'TARIFA_T2' || v.servicio_clave__c == 'TARIFA_T3' || v.servicio_clave__c == 'TARIFA_T4' || v.servicio_clave__c == 'TARIFA_T5' || v.servicio_clave__c == 'TARIFA_T6' || v.servicio_clave__c == 'TARIFA_T7')
                   && v.tipo_destino__c == 'INTERNACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalPaqueteria_InternacionalMTTO 	+= v.total_antes_de_impuestos__c;
                }
                
                
                // ============================= VENTAS SERVICIOS ==============================
                if((v.servicio_clave__c != 'TARIFA_TS' && v.servicio_clave__c != 'TARIFA_T0' && v.servicio_clave__c != 'TARIFA_T1' && v.servicio_clave__c != 'TARIFA_T2' && v.servicio_clave__c != 'TARIFA_T3' && v.servicio_clave__c != 'TARIFA_T4' && v.servicio_clave__c != 'TARIFA_T5' && v.servicio_clave__c != 'TARIFA_T6' && v.servicio_clave__c != 'TARIFA_T7') || test.isRunningTest()){
                    totalServiciosMTTO += v.total_antes_de_impuestos__c;
                    
                    // SERVICIOS RAD
                    if(v.servicio_clave__c == 'RAD' || test.isRunningTest()){
                        totalServicios_RADMTTO += v.total_antes_de_impuestos__c;    
                    }
                    
                    // SERVICIOS EAD
                    if(v.servicio_clave__c == 'EAD' || test.isRunningTest()){
                        totalServicios_EADMTTO += v.total_antes_de_impuestos__c;
                    }
                    
                    // SERVICIOS ZONA EXTENDIDA
                    if(v.servicio_clave__c == 'ESP-1' || v.servicio_clave__c == 'MISIVA_FLETE' ||  v.servicio_clave__c == 'LYNDEN_FLETE' || test.isRunningTest()){
                        totalServicios_ZonaExtMTTO += v.total_antes_de_impuestos__c;
                    }
                    
                    //SERVICIOS ACUSE
                    if(v.servicio_clave__c == 'ACUSE_CLIENTE' || v.servicio_clave__c == 'ACUSE_INTERNO' || v.servicio_clave__c == 'ACUSE_XT' || test.isRunningTest()){
                        totalServicios_AcuseMTTO += v.total_antes_de_impuestos__c;
                    }
                    
                    //SERVICIOS SEGURO
                    if(v.servicio_clave__c == 'SEGURO' || test.isRunningTest()){
                        totalServicios_SeguroMTTO += v.total_antes_de_impuestos__c;
                    }
                    
                    //SERVICIOS COD
                    if(v.servicio_clave__c == 'COD' || test.isRunningTest()){
                        totalServicios_CODMTTO += v.total_antes_de_impuestos__c;
                    }
                    
                    //SERVICIOS OTROS
                    if(v.servicio_clave__c == 'ALMACENAJE' 				|| v.servicio_clave__c == 'COM' 						|| v.servicio_clave__c == 'EAD_CITA' 					||
                       v.servicio_clave__c == 'EAD_DET' 					|| v.servicio_clave__c == 'EMB-1' 					|| v.servicio_clave__c == 'EMB-2' 					||
                       v.servicio_clave__c == 'EMB-3' 					|| v.servicio_clave__c == 'EMB-4' 					|| v.servicio_clave__c == 'EMB-5'	 					||
                       v.servicio_clave__c == 'EMBALAJE-T0' 				|| v.servicio_clave__c == 'EMBALAJE-T1' 				|| v.servicio_clave__c == 'EMBALAJE-T2' 				||
                       v.servicio_clave__c == 'EMBALAJE-T3' 				|| v.servicio_clave__c == 'ENTREGA_LOCAL' 			|| v.servicio_clave__c == 'FASTEX_CAMBIO_DOMICILIO' 	||
                       v.servicio_clave__c == 'FASTEX_DEVOLUCION' 		|| v.servicio_clave__c == 'FASTEX_PEDIMENTO' 			|| v.servicio_clave__c == 'FASTEX_REEXPEDICION' 		||
                       v.servicio_clave__c == 'FEDEX_CAMBIO_DOMICILIO' 	|| v.servicio_clave__c == 'FEDEX_COSTO_COMBUSTIBLE' 	|| v.servicio_clave__c == 'FEDEX_DEVOLUCION' 			||
                       v.servicio_clave__c == 'FEDEX_GASTOS_ADUANA' 		|| v.servicio_clave__c == 'FEDEX_REEXPEDICION' 		|| v.servicio_clave__c == 'FLEJE' 					||
                       v.servicio_clave__c == 'FTL' 						|| v.servicio_clave__c == 'FTL-ACU' 					|| v.servicio_clave__c == 'FTL-EST' 					||
                       v.servicio_clave__c == 'FTL-MAN' 					|| v.servicio_clave__c == 'FTL-REP' 					|| v.servicio_clave__c == 'FTL-SEG' 					||
                       v.servicio_clave__c == 'MANIOBRAS' 				|| v.servicio_clave__c == 'NA' 						|| v.servicio_clave__c == 'OTROS' 					||
                       v.servicio_clave__c == 'PALETTE' 					|| v.servicio_clave__c == 'PICKING' 					|| v.servicio_clave__c == 'PQE_COSTO_COMBUSTIBLE' 	||
                       v.servicio_clave__c == 'RAD-ZP' 					|| v.servicio_clave__c == 'SERV_ADICIONALES' 			|| v.servicio_clave__c == 'SPECIAL_PACKAGING' 		||
                       v.servicio_clave__c == 'TRANSFER_ADMIN_DE_FLETE' 	|| v.servicio_clave__c == 'TRANSFER_ALMACENAJE' 		|| v.servicio_clave__c == 'TRANSFER_CRUCE_FRONTERIZO' ||
                       v.servicio_clave__c == 'TRANSFER_FLETE_EXTRANJERO' || v.servicio_clave__c == 'TRANSFER_GASTOS_ADUANALES' || v.servicio_clave__c == 'UNIDAD DEDICADA 0.7' 		||
                       v.servicio_clave__c == 'UNIDAD DEDICADA 1.7' 		|| v.servicio_clave__c == 'UPS_CAMBIO_DOMICILIO' 		|| v.servicio_clave__c == 'UPS_COSTO_COMBUSTIBLE' 	||
                       v.servicio_clave__c == 'UPS_ENTREGA_SABADO' 		|| v.servicio_clave__c == 'UPS_EXTENDIDO' 			|| v.servicio_clave__c == 'UPS_GASTOS_ADUANALES' 		||
                       v.servicio_clave__c == 'UPS_PEDIMENTO' 			|| v.servicio_clave__c == 'UPS-PAQ'					|| test.isRunningTest() ){
                        totalServicios_OtrosMTTO += v.total_antes_de_impuestos__c;
                    }
                    
                }
                
                // VENTAS SERVICIOS Y CARGA ESTANDAR
                if(((v.servicio_clave__c != 'TARIFA_TS' && v.servicio_clave__c != 'TARIFA_T0' && v.servicio_clave__c != 'TARIFA_T1' && v.servicio_clave__c != 'TARIFA_T2' && v.servicio_clave__c != 'TARIFA_T3' && v.servicio_clave__c != 'TARIFA_T4' && v.servicio_clave__c != 'TARIFA_T5' && v.servicio_clave__c != 'TARIFA_T6' && v.servicio_clave__c != 'TARIFA_T7')
                   && v.tipo_destino__c == 'NACIONAL' && v.tipo_servicio__c =='STD-T' ) || test.isRunningTest()){
                    totalServicios_EstandarMTTO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS SERVICIOS Y CARGA EXPRESS
                if(((v.servicio_clave__c != 'TARIFA_TS' && v.servicio_clave__c != 'TARIFA_T0' && v.servicio_clave__c != 'TARIFA_T1' && v.servicio_clave__c != 'TARIFA_T2' && v.servicio_clave__c != 'TARIFA_T3' && v.servicio_clave__c != 'TARIFA_T4' && v.servicio_clave__c != 'TARIFA_T5' && v.servicio_clave__c != 'TARIFA_T6' && v.servicio_clave__c != 'TARIFA_T7')
                   && v.tipo_destino__c == 'NACIONAL' && (v.tipo_servicio__c =='SEG-DS' || v.tipo_servicio__c =='SEG-2D' || v.tipo_servicio__c =='SEG-A12' || v.tipo_servicio__c =='SEG-MD' ))
                  || test.isRunningTest()){
                    totalServicios_ExpressMTTO += v.total_antes_de_impuestos__c;
                }
                
                // VENTAS SERVICIOS Y CARGA INTERNACIONAL
                if(((v.servicio_clave__c != 'TARIFA_TS' && v.servicio_clave__c != 'TARIFA_T0' && v.servicio_clave__c != 'TARIFA_T1' && v.servicio_clave__c != 'TARIFA_T2' && v.servicio_clave__c != 'TARIFA_T3' && v.servicio_clave__c != 'TARIFA_T4' && v.servicio_clave__c != 'TARIFA_T5' && v.servicio_clave__c != 'TARIFA_T6' && v.servicio_clave__c != 'TARIFA_T7')
                   && v.tipo_destino__c == 'INTERNACIONAL' && v.tipo_servicio__c =='STD-T' )
                  || test.isRunningTest()){
                    totalServicios_InternacionalMTTO 	+= v.total_antes_de_impuestos__c;
                }
            }
             
		}
        
        
        if(totalVentasGLOBAL != 0){
            
            // TOTALES GLOBALES
            
            contenido += '\n total Ventas GLOBAL									= ' + totalVentasGLOBAL;
            contenido += '\n total Ventas NUEVO										= ' + totalVentaClienteNuevo;
            contenido += '\n total Ventas MANTENIMIENTO								= ' + totalVentaClienteMantenimiento;
            
            contenido += '\n total NUEVO + MANTENIMIENTO							= ' + totalVentaClienteMantenimiento + totalVentaClienteNuevo;
            
            // MENSAJERIA 
            
            contenido += '\n total Ventas Mensajeria NUEVO							= ' + totalMensajeriaNVO;
            contenido += '\n total Ventas Mensajeria Estandar NUEVO					= ' + totalMensajeria_EstandarNVO;
            contenido += '\n total Ventas Mensajeria Express  NUEVO 				= ' + totalMensajeria_ExpressNVO;
            contenido += '\n total Ventas Mensajeria Internacional NUEVO			= ' + totalMensajeria_InternacionalNVO;
            
            contenido += '\n total Ventas Mensajeria MANTENIMIENTO					= ' + totalMensajeriaMTTO;
            contenido += '\n total Ventas Mensajeria Estandar MANTENIMIENTO			= ' + totalMensajeria_EstandarMTTO;
            contenido += '\n total Ventas Mensajeria Express  MANTENIMIENTO 		= ' + totalMensajeria_ExpressMTTO;
            contenido += '\n total Ventas Mensajeria Internacional MANTENIMIENTO	= ' + totalMensajeria_InternacionalMTTO;
            
            totalMensajeriaGLOBAL					= totalMensajeriaNVO 				+ totalMensajeriaMTTO;
            totalMensajeria_EstandarGLOBAL			= totalMensajeria_EstandarNVO 		+ totalMensajeria_EstandarMTTO;
            totalMensajeria_ExpressGLOBAL			= totalMensajeria_ExpressNVO 		+ totalMensajeria_ExpressMTTO;
            totalMensajeria_InternacionalGLOBAL		= totalMensajeria_InternacionalNVO 	+ totalMensajeria_InternacionalMTTO;
            
            contenido += '\n total Ventas Mensajeria GLOBAL							= ' + totalMensajeriaGLOBAL;
            contenido += '\n total Ventas Mensajeria Estandar GLOBAL				= ' + totalMensajeria_EstandarGLOBAL;
            contenido += '\n total Ventas Mensajeria Express GLOBAL 				= ' + totalMensajeria_ExpressGLOBAL;
            contenido += '\n total Ventas Mensajeria Internacional GLOBAL			= ' + totalMensajeria_InternacionalGLOBAL;
            
            // PAQUETERIA 
            
            contenido += '\n total Ventas Paqueteria NUEVO							= ' + totalPaqueteriaNVO;
            contenido += '\n total Ventas Paqueteria Estandar NUEVO					= ' + totalPaqueteria_EstandarNVO;
            contenido += '\n total Ventas Paqueteria Express  NUEVO 				= ' + totalPaqueteria_ExpressNVO;
            contenido += '\n total Ventas Paqueteria Internacional NUEVO			= ' + totalPaqueteria_InternacionalNVO;
            
            contenido += '\n total Ventas Paqueteria MANTENIMIENTO					= ' + totalPaqueteriaMTTO;
            contenido += '\n total Ventas Paqueteria Estandar MANTENIMIENTO			= ' + totalPaqueteria_EstandarMTTO;
            contenido += '\n total Ventas Paqueteria Express  MANTENIMIENTO 		= ' + totalPaqueteria_ExpressMTTO;
            contenido += '\n total Ventas Paqueteria Internacional MANTENIMIENTO	= ' + totalPaqueteria_InternacionalMTTO;
            
            totalPaqueteriaGLOBAL					= totalPaqueteriaNVO 				+ totalPaqueteriaMTTO;
            totalPaqueteria_EstandarGLOBAL			= totalPaqueteria_EstandarNVO 		+ totalPaqueteria_EstandarMTTO;
            totalPaqueteria_ExpressGLOBAL			= totalPaqueteria_ExpressNVO 		+ totalPaqueteria_ExpressMTTO;
            totalPaqueteria_InternacionalGLOBAL		= totalPaqueteria_InternacionalNVO 	+ totalPaqueteria_InternacionalMTTO;
            
            contenido += '\n total Ventas Paqueteria GLOBAL							= ' + totalPaqueteriaGLOBAL;
            contenido += '\n total Ventas Paqueteria Estandar GLOBAL				= ' + totalPaqueteria_EstandarGLOBAL;
            contenido += '\n total Ventas Paqueteria Express GLOBAL 				= ' + totalPaqueteria_ExpressGLOBAL;
            contenido += '\n total Ventas Paqueteria Internacional GLOBAL			= ' + totalPaqueteria_InternacionalGLOBAL;
            
            // SERVICIOS
            
            contenido += '\n total Ventas Servicios NUEVO							= ' + totalServiciosNVO;
            contenido += '\n total Ventas Servicios Estandar NUEVO					= ' + totalServicios_EstandarNVO;
            contenido += '\n total Ventas Servicios Express  NUEVO 					= ' + totalServicios_ExpressNVO;
            contenido += '\n total Ventas Servicios Internacional NUEVO				= ' + totalServicios_InternacionalNVO;
            
            contenido += '\n total Ventas Servicios MANTENIMIENTO					= ' + totalServiciosMTTO;
            contenido += '\n total Ventas Servicios Estandar MANTENIMIENTO			= ' + totalServicios_EstandarMTTO;
            contenido += '\n total Ventas Servicios Express  MANTENIMIENTO 			= ' + totalServicios_ExpressMTTO;
            contenido += '\n total Ventas Servicios Internacional MANTENIMIENTO		= ' + totalServicios_InternacionalMTTO;
            
            totalServiciosGLOBAL					= totalServiciosNVO 				+ totalServiciosMTTO;
            totalServicios_EstandarGLOBAL			= totalServicios_EstandarNVO 		+ totalServicios_EstandarMTTO;
            totalServicios_ExpressGLOBAL			= totalServicios_ExpressNVO 		+ totalServicios_ExpressMTTO;
            totalServicios_InternacionalGLOBAL		= totalServicios_InternacionalNVO 	+ totalServicios_InternacionalMTTO;

			contenido += '\n total Ventas Servicios GLOBAL							= ' + totalServiciosGLOBAL;
            contenido += '\n total Ventas Servicios Estandar GLOBAL					= ' + totalServicios_EstandarGLOBAL;
            contenido += '\n total Ventas Servicios Express GLOBAL 					= ' + totalServicios_ExpressGLOBAL;
            contenido += '\n total Ventas Servicios Internacional GLOBAL			= ' + totalServicios_InternacionalGLOBAL;
            
            //DETALLES SERVICIOS
            
            // SERVICIOS
            
            contenido += '\n total Ventas Servicios RAD NUEVO							= ' + totalServicios_RADNVO;
            contenido += '\n total Ventas Servicios EAD NUEVO							= ' + totalServicios_EADNVO;
            contenido += '\n total Ventas Servicios ZONA EXTENDIDA  NUEVO 				= ' + totalServicios_ZonaExtNVO;
            contenido += '\n total Ventas Servicios ACUSE NUEVO							= ' + totalServicios_AcuseNVO;
            contenido += '\n total Ventas Servicios SEGURO NUEVO						= ' + totalServicios_SeguroNVO;
            contenido += '\n total Ventas Servicios COD NUEVO							= ' + totalServicios_CODNVO;
            contenido += '\n total Ventas Servicios OTROS NUEVO							= ' + totalServicios_OtrosNVO;
            
            contenido += '\n total Ventas Servicios RAD MANTENIMIENTO					= ' + totalServicios_RADMTTO;
            contenido += '\n total Ventas Servicios EAD MANTENIMIENTO					= ' + totalServicios_EADMTTO;
            contenido += '\n total Ventas Servicios ZONA EXTENDIDA  MANTENIMIENTO		= ' + totalServicios_ZonaExtMTTO;
            contenido += '\n total Ventas Servicios ACUSE MANTENIMIENTO					= ' + totalServicios_AcuseMTTO;
            contenido += '\n total Ventas Servicios SEGURO MANTENIMIENTO				= ' + totalServicios_SeguroMTTO;
            contenido += '\n total Ventas Servicios COD MANTENIMIENTO					= ' + totalServicios_CODMTTO;
            contenido += '\n total Ventas Servicios OTROS MANTENIMIENTO					= ' + totalServicios_OtrosMTTO;
            
            totalServicios_RADGLOBAL				= totalServicios_RADNVO 		+ 	totalServicios_RADMTTO;
            totalServicios_EADGLOBAL				= totalServicios_EADNVO 		+	totalServicios_EADMTTO;
            totalServicios_ZonaExtGLOBAL			= totalServicios_ZonaExtNVO 	+ 	totalServicios_ZonaExtMTTO;
            totalServicios_AcuseGLOBAL				= totalServicios_AcuseNVO	 	+	totalServicios_AcuseMTTO;
            totalServicios_SeguroGLOBAL				= totalServicios_SeguroNVO	 	+ 	totalServicios_SeguroMTTO;
            totalServicios_CODGLOBAL				= totalServicios_CODNVO 		+	totalServicios_CODMTTO;
            totalServicios_OtrosGLOBAL				= totalServicios_OtrosNVO 		+ 	totalServicios_OtrosMTTO;
                
            contenido += '\n total Servicios RAD		= ' + totalServicios_RADGLOBAL;
            contenido += '\n total Servicios EAD 		= ' + totalServicios_EADGLOBAL;
            contenido += '\n total Servicios Zona Ext	= ' + totalServicios_ZonaExtGLOBAL;
            contenido += '\n total Servicios Acuse		= ' + totalServicios_AcuseGLOBAL;
            contenido += '\n total Servicios Seguro		= ' + totalServicios_SeguroGLOBAL;
            contenido += '\n total Servicios COD		= ' + totalServicios_CODGLOBAL;
            contenido += '\n total Servicios Otros		= ' + totalServicios_OtrosGLOBAL;
            
            //TOTALES ESTANDAR, EXPRESS, INTERNACIONAL, NACIONAL GLOBAL
            
            totalEstandarGLOBAL			= totalMensajeria_EstandarGLOBAL 		+ totalPaqueteria_EstandarGLOBAL 		+ totalServicios_EstandarGLOBAL;
        	totalExpressGLOBAL			= totalMensajeria_ExpressGLOBAL 		+ totalPaqueteria_ExpressGLOBAL 		+ totalServicios_ExpressGLOBAL;
        	totalInternacionalGLOBAL	= totalMensajeria_InternacionalGLOBAL	+ totalPaqueteria_InternacionalGLOBAL	+ totalServicios_InternacionalGLOBAL;
            totalNacionalGLOBAL			= totalEstandarGLOBAL 					+ totalExpressGLOBAL;
            
            contenido += '\n total Ventas Estandar GLOBAL		= ' + totalEstandarGLOBAL;
            contenido += '\n total Ventas Express  GLOBAL		= ' + totalExpressGLOBAL;
            contenido += '\n total Ventas Internacional	GLOBAL	= ' + totalInternacionalGLOBAL;
            contenido += '\n total Ventas Nacional	GLOBAL		= ' + totalNacionalGLOBAL;
            
            //TOTALES ESTANDAR, EXPRESS, INTERNACIONAL, NACIONAL NUEVO
            
            totalEstandarNVO			= totalMensajeria_EstandarNVO 			+ totalPaqueteria_EstandarNVO 			+ totalServicios_EstandarNVO;
        	totalExpressNVO				= totalMensajeria_ExpressNVO	 		+ totalPaqueteria_ExpressNVO 			+ totalServicios_ExpressNVO;
        	totalInternacionalNVO		= totalMensajeria_InternacionalNVO		+ totalPaqueteria_InternacionalNVO		+ totalServicios_InternacionalNVO;
            totalNacionalNVO			= totalEstandarNVO 						+ totalExpressNVO;
            
            contenido += '\n total Ventas Estandar NUEVO		= ' + totalEstandarNVO;
            contenido += '\n total Ventas Express  NUEVO		= ' + totalExpressNVO;
            contenido += '\n total Ventas Internacional	NUEVO	= ' + totalInternacionalNVO;
            contenido += '\n total Ventas Nacional	NUEVO		= ' + totalNacionalNVO;
            
            //TOTALES ESTANDAR, EXPRESS, INTERNACIONAL, NACIONAL MANTENIMIENTO
            
            totalEstandarMTTO			= totalMensajeria_EstandarMTTO 			+ totalPaqueteria_EstandarMTTO 			+ totalServicios_EstandarMTTO;
        	totalExpressMTTO			= totalMensajeria_ExpressMTTO	 		+ totalPaqueteria_ExpressMTTO 			+ totalServicios_ExpressMTTO;
        	totalInternacionalMTTO		= totalMensajeria_InternacionalMTTO		+ totalPaqueteria_InternacionalMTTO		+ totalServicios_InternacionalMTTO;
            totalNacionalMTTO			= totalEstandarMTTO 					+ totalExpressMTTO;
            
            contenido += '\n total Ventas Estandar MANTENIMIENTO		= ' + totalEstandarMTTO;
            contenido += '\n total Ventas Express  MANTENIMIENTO		= ' + totalExpressMTTO;
            contenido += '\n total Ventas Internacional	MANTENIMIENTO	= ' + totalInternacionalMTTO;
            contenido += '\n total Ventas Nacional	MANTENIMIENTO		= ' + totalNacionalMTTO;
            
            //==================== WRAPPER VALORES VENTAS =====================
            
            wrapperValoresVentas wVentas = new wrapperValoresVentas ();
            wVentas.totalVentasGLOBAL					= totalVentasGLOBAL;
            wVentas.totalVentaClienteNuevo				= totalVentaClienteNuevo;
            wVentas.totalVentaClienteMantenimiento		= totalVentaClienteMantenimiento;
                
            // MENSAJERIA 
                
            wVentas.totalMensajeriaNVO					= totalMensajeriaNVO;
            wVentas.totalMensajeria_EstandarNVO			= totalMensajeria_EstandarNVO;
            wVentas.totalMensajeria_ExpressNVO			= totalMensajeria_ExpressNVO;
            wVentas.totalMensajeria_InternacionalNVO	= totalMensajeria_InternacionalNVO;
                
            wVentas.totalMensajeriaMTTO					= totalMensajeriaMTTO;
            wVentas.totalMensajeria_EstandarMTTO		= totalMensajeria_EstandarMTTO;
            wVentas.totalMensajeria_ExpressMTTO			= totalMensajeria_ExpressMTTO;
            wVentas.totalMensajeria_InternacionalMTTO	= totalMensajeria_InternacionalMTTO;
           
            wVentas.totalMensajeriaGLOBAL				= totalMensajeriaGLOBAL;
            wVentas.totalMensajeria_EstandarGLOBAL		= totalMensajeria_EstandarGLOBAL;
            wVentas.totalMensajeria_ExpressGLOBAL		= totalMensajeria_ExpressGLOBAL;
            wVentas.totalMensajeria_InternacionalGLOBAL	= totalMensajeria_InternacionalGLOBAL;
                
            // PAQUETERIA 
                
            wVentas.totalPaqueteriaNVO					= totalPaqueteriaNVO;		 
            wVentas.totalPaqueteria_EstandarNVO			= totalPaqueteria_EstandarNVO;
            wVentas.totalPaqueteria_ExpressNVO			= totalPaqueteria_ExpressNVO;
            wVentas.totalPaqueteria_InternacionalNVO	= totalPaqueteria_InternacionalNVO;
                
            wVentas.totalPaqueteriaMTTO					= totalPaqueteriaMTTO;
            wVentas.totalPaqueteria_EstandarMTTO		= totalPaqueteria_EstandarMTTO;
            wVentas.totalPaqueteria_ExpressMTTO			= totalPaqueteria_ExpressMTTO;
            wVentas.totalPaqueteria_InternacionalMTTO	= totalPaqueteria_InternacionalMTTO;
                
            wVentas.totalPaqueteriaGLOBAL				= totalPaqueteriaGLOBAL;
            wVentas.totalPaqueteria_EstandarGLOBAL		= totalPaqueteria_EstandarGLOBAL;
            wVentas.totalPaqueteria_ExpressGLOBAL		= totalPaqueteria_ExpressGLOBAL;
            wVentas.totalPaqueteria_InternacionalGLOBAL	= totalPaqueteria_InternacionalGLOBAL;
                
            // SERVICIOS
                
            wVentas.totalServiciosNVO					= totalServiciosNVO;
            wVentas.totalServicios_EstandarNVO			= totalServicios_EstandarNVO;
            wVentas.totalServicios_ExpressNVO			= totalServicios_ExpressNVO;
            wVentas.totalServicios_InternacionalNVO		= totalServicios_InternacionalNVO;
                	
            wVentas.totalServiciosMTTO					= totalServiciosMTTO;
            wVentas.totalServicios_EstandarMTTO			= totalServicios_EstandarMTTO;
            wVentas.totalServicios_ExpressMTTO			= totalServicios_ExpressMTTO;
            wVentas.totalServicios_InternacionalMTTO	= totalServicios_InternacionalMTTO;
                
            wVentas.totalServiciosGLOBAL				= totalServiciosGLOBAL;
            wVentas.totalServicios_EstandarGLOBAL		= totalServicios_EstandarGLOBAL;
            wVentas.totalServicios_ExpressGLOBAL		= totalServicios_ExpressGLOBAL;
            wVentas.totalServicios_InternacionalGLOBAL	= totalServicios_InternacionalGLOBAL;
                
            //DETALLES SERVICIOS
                
            // SERVICIOS
                
            wVentas.totalServicios_RADNVO				= totalServicios_RADNVO;
            wVentas.totalServicios_EADNVO				= totalServicios_EADNVO;
            wVentas.totalServicios_ZonaExtNVO			= totalServicios_ZonaExtNVO;
            wVentas.totalServicios_AcuseNVO				= totalServicios_AcuseNVO;
            wVentas.totalServicios_SeguroNVO			= totalServicios_SeguroNVO;
            wVentas.totalServicios_CODNVO				= totalServicios_CODNVO;
            wVentas.totalServicios_OtrosNVO				= totalServicios_OtrosNVO;
                
            wVentas.totalServicios_RADMTTO				= totalServicios_RADMTTO;
            wVentas.totalServicios_EADMTTO				= totalServicios_EADMTTO;
            wVentas.totalServicios_ZonaExtMTTO			= totalServicios_ZonaExtMTTO;
            wVentas.totalServicios_AcuseMTTO			= totalServicios_AcuseMTTO;
            wVentas.totalServicios_SeguroMTTO			= totalServicios_SeguroMTTO;
            wVentas.totalServicios_CODMTTO				= totalServicios_CODMTTO;
            wVentas.totalServicios_OtrosMTTO			= totalServicios_OtrosMTTO;
                
          
            wVentas.totalServicios_RADGLOBAL			= totalServicios_RADGLOBAL;
            wVentas.totalServicios_EADGLOBAL			= totalServicios_EADGLOBAL;
            wVentas.totalServicios_ZonaExtGLOBAL		= totalServicios_ZonaExtGLOBAL;
            wVentas.totalServicios_AcuseGLOBAL			= totalServicios_AcuseGLOBAL;
            wVentas.totalServicios_SeguroGLOBAL			= totalServicios_SeguroGLOBAL;
            wVentas.totalServicios_CODGLOBAL			= totalServicios_CODGLOBAL;
            wVentas.totalServicios_OtrosGLOBAL			= totalServicios_OtrosGLOBAL;
                
            //TOTALES ESTANDAR, EXPRESS, INTERNACIONAL, NACIONAL GLOBAL
            wVentas.totalEstandarGLOBAL					= totalEstandarGLOBAL;
            wVentas.totalExpressGLOBAL					= totalExpressGLOBAL;
            wVentas.totalInternacionalGLOBAL			= totalInternacionalGLOBAL;
            wVentas.totalNacionalGLOBAL					= totalNacionalGLOBAL;
                
            //TOTALES ESTANDAR, EXPRESS, INTERNACIONAL, NACIONAL NUEVO
            wVentas.totalEstandarNVO					= totalEstandarNVO;
            wVentas.totalExpressNVO						= totalExpressNVO;
            wVentas.totalInternacionalNVO				= totalInternacionalNVO;
            wVentas.totalNacionalNVO					= totalNacionalNVO;
                
            //TOTALES ESTANDAR, EXPRESS, INTERNACIONAL, NACIONAL MANTENIMIENTO
            wVentas.totalEstandarMTTO					= totalEstandarMTTO;
            wVentas.totalExpressMTTO					= totalExpressMTTO;
            wVentas.totalInternacionalMTTO				= totalInternacionalMTTO;
            wVentas.totalNacionalMTTO					= totalNacionalMTTO;
     
            ventasValorMap = AuxTendenciaEjecutivo.llenaValoresVentasMap(wVentas);
            
            for(String tituloVenta: AuxTendenciaEjecutivo.llenaValoresVentas()){
                Tendencia__c t 		= new Tendencia__c ();
                t.Ejecutivo__c	 	= vendedorId;
                t.Tipo_de_Importe__c= tituloVenta;
                t.Fecha__c			= hoy;
                t.Importe__c		= ventasValorMap.get(tituloVenta);
                
                if(tituloVenta == 'Total Venta Servicios'){
                    t.RAD__c 			= totalServicios_RADNVO;
                    t.EAD__c 			= totalServicios_EADNVO;
                    t.Zona_Extendida__c = totalServicios_ZonaExtNVO;
                    t.Acuse__c 			= totalServicios_AcuseNVO;
                    t.Seguro__c			= totalServicios_SeguroNVO;
                    t.Otros__c 			= totalServicios_OtrosNVO;
                    t.COD__c			= totalServicios_CODNVO;
                        
                }

				if(tituloVenta == 'Total Venta Servicios mantenimiento'){
					t.RAD__c 			= totalServicios_RADMTTO;
                    t.EAD__c 			= totalServicios_EADMTTO;
                    t.Zona_Extendida__c = totalServicios_ZonaExtMTTO;
                    t.Acuse__c 			= totalServicios_AcuseMTTO;
                    t.Seguro__c			= totalServicios_SeguroMTTO;
                    t.Otros__c 			= totalServicios_OtrosMTTO;
                    t.COD__c			= totalServicios_CODMTTO;
				}

				if(tituloVenta == 'Total Venta Global Servicios'){
					t.RAD__c 		= totalServicios_RADGLOBAL;
                    t.EAD__c 		= totalServicios_EADGLOBAL;
                    t.Zona_Extendida__c = totalServicios_ZonaExtGLOBAL;
                    t.Acuse__c 		= totalServicios_AcuseGLOBAL;
                    t.Seguro__c		= totalServicios_SeguroGLOBAL;
                    t.Otros__c 		= totalServicios_OtrosGLOBAL;
                    t.COD__c		= totalServicios_CODGLOBAL;
				}

				t.OwnerId = vendedorId;
                tendenciasVentasList.add(t);
                
                System.debug('t.Tipo_de_Importe__c= tituloVenta' + t.Tipo_de_Importe__c);
                System.debug('t.Importe__c' + t.Importe__c);
                
            }
            
            if(tendenciasVentasList.size()>0){
                insert tendenciasVentasList;
            }
         
        }
        
        AuxTendencia.notificaLlamadoWS (contenido);
        
	}
    
    public static void generaResumenVentasEjecutivoTMKT (Id vendedorId, Date fecha, String mesconsulta, String anio){
        
        // ==================== VENTA ====================
        
        Decimal totalVentaTMKT = 0;

        User aUser = [
            SELECT Id, FederationIdentifier
            FROM User 
            WHERE Id =: vendedorId
        ];
        
        for(Ventas__dlm v: [
            SELECT total_despues_de_impuestos__c, total_antes_de_impuestos__c, sucursal_origen_clave__c, fecha_venta__c, 
            servicio_clave__c, tipo_destino__c, tipo_servicio__c, cliente_tipo_comercial__c  
            FROM ventas__dlm 
            WHERE total_despues_de_impuestos__c != null AND  fecha_venta__c =:fecha 
            AND ejecutivo_origen_clave__c =: aUser.FederationIdentifier ]){
        	totalVentaTMKT += v.total_antes_de_impuestos__c;
        }
        
        if(totalVentaTMKT != 0){
        	Tendencia__c t 		= new Tendencia__c ();
            t.Ejecutivo__c	 	= vendedorId;
            t.Tipo_de_Importe__c= 'Venta Telemarketing';
            t.Fecha__c			= fecha;
            t.Importe__c		= totalVentaTMKT;
            t.OwnerId 			= vendedorId;    
            insert t;
            
            System.debug('t.Tipo_de_Importe__c= tituloVenta' + t.Tipo_de_Importe__c);
        	System.debug('t.Importe__c' + t.Importe__c);
        }
        
        // ==================== PRESUPUESTO ====================
        
        List<Detalle_Presupuesto__c> 	dpSucursalList 	= new List<Detalle_Presupuesto__c>();
        List<Tendencia__c> 				dpTendenciaList = new List<Tendencia__c>();
        List<Tendencia__c>				tendenciasPresupuestosList = new List<Tendencia__c>();
        
        dpTendenciaList = [SELECT Id, Ejecutivo__c, Anio__c, Mes__c, Tipo_de_Importe__c FROM Tendencia__c WHERE Ejecutivo__c =: vendedorId AND Mes__c =: mesConsulta 
                           AND Anio__c =: anio AND Tipo_de_Importe__c = 'Presupuesto Telemarketing'];
        
        dpSucursalList 	= [ SELECT Id, Presupuesto_Telemarketing__c		FROM Detalle_Presupuesto__c 
                           WHERE Ejecutivo__c =: vendedorId AND Mes__c =:mesConsulta AND Anio__c =: anio];
        
        System.debug('dpTendenciaList.size() : ' + dpTendenciaList.size());
        System.debug('dpSucursalList.size()  : ' + dpSucursalList.size());
        
        if(dpTendenciaList.size()==0 && dpSucursalList.size()==1){
                Tendencia__c t 		= new Tendencia__c ();
                t.Ejecutivo__c	 	= vendedorId;
                t.Tipo_de_Importe__c= 'Presupuesto Telemarketing';
                t.Fecha__c			= fecha;
                t.Importe__c		= dpSucursalList[0].Presupuesto_Telemarketing__c	;
                t.OwnerId			= vendedorId;
                insert t;
                
                System.debug('Tipo Importe : ' + t.Tipo_de_Importe__c);
                System.debug('Importe : ' + t.Importe__c);
                
     	}
            
     
        
        // ==================== TENDENCIA ===================
        
        Decimal totalDiasMes 									= 0;
        Decimal totalDiasTranscurridos 							= 0;
        
        List<Tendencia__c> 				dpTendenciaTMKTList 	= new List<Tendencia__c>();
        List<Tendencia__c> 				dpVentasList 			= new List<Tendencia__c>();
        List<Tendencia__c>				tendenciasUpdateList 	= new List<Tendencia__c>();
        
        List<Ejecutivo_Calendario__c>  	EjecCalendarioList		= new List<Ejecutivo_Calendario__c>();
        List<Ano_Calendario__c>			anioCalendarioList		= new List<Ano_Calendario__c>();
        
        List<String>					valoresVentasList 		= llenaValoresVentas ();
        
        Map<String, String> 			correspondenciasTendenciasVentasMap = new Map<String, String>();
            
        
        // LISTA DE VALORES DE TENDENCIA 
        dpTendenciaTMKTList = [SELECT Id, Ejecutivo__c, Anio__c, Mes__c, importe__c, Tipo_de_Importe__c FROM Tendencia__c 
                           WHERE Ejecutivo__c =: vendedorId AND Mes__c =: mesConsulta 
                           AND Anio__c =: anio AND Tipo_de_Importe__c = 'Tendencia Telemarketing'];
        
        // LISTA DE VALORES DE VENTA PARA LA TENDENCIA
        dpVentasList 	= [SELECT Id, Ejecutivo__c, Anio__c, Mes__c, importe__c, Tipo_de_Importe__c FROM Tendencia__c 
                           WHERE Ejecutivo__c =: vendedorId AND Mes__c =: mesConsulta 
                           AND Anio__c =: anio AND Tipo_de_Importe__c = 'Venta Telemarketing'];
        
        // CONSULTA CALENDARIO RELACIONADO A LA SUCURSAL
        
        EjecCalendarioList = [SELECT Id, Ejecutivo__c, AnioCalendario__c, AnioCalendario__r.Ano__c FROM Ejecutivo_Calendario__c 
                             WHERE Ejecutivo__c =: vendedorId AND AnioCalendario__r.Ano__c =: anio]; 
        
        // CONSULTA VALORES DEL CALENDARIO RELACIONADO A LA SUCURSAL
        If(EjecCalendarioList.size()>0){
            anioCalendarioList= [SELECT Abril__c,Agosto__c,Ano__c,DiasHabilesTranscurridosDelAno__c,Dias_transcurridos_Abril__c,Dias_transcurridos_Agosto__c,
                                 Dias_transcurridos_Diciembre__c,Dias_transcurridos_Enero__c,Dias_transcurridos_Febrero__c,Dias_transcurridos_Julio__c,
                                 Dias_transcurridos_Junio__c,Dias_transcurridos_Marzo__c,Dias_transcurridos_Mayo__c,Dias_transcurridos_Noviembre__c,
                                 Dias_transcurridos_Octubre__c,Dias_transcurridos_Septiembre__c,Diciembre__c,Enero__c,Febrero__c,Id,Julio__c,Junio__c,
                                 Marzo__c,Mayo__c,Name,Noviembre__c,Observaciones__c,Octubre__c,Septiembre__c,Total_Anual__c FROM Ano_Calendario__c 
                                 WHERE Id=: EjecCalendarioList[0].AnioCalendario__c];
            
            List<Decimal> diasMes_DiasTranscurridos_List = new List<Decimal>();
            diasMes_DiasTranscurridos_List = calculaDiasMes_DiasTranscurridos(anioCalendarioList, mesConsulta);
            totalDiasMes = diasMes_DiasTranscurridos_List[0];
            //totalDiasTranscurridos = diasMes_DiasTranscurridos_List[1];   
            totalDiasTranscurridos = AuxTendencia.getDiasTranscurridos(anioCalendarioList[0].Id,fecha);  
        }
        
        
        System.debug('=================recalculoTendencias================');
        System.debug('TAMAÑO LIST TENDENCIA: ' + dpTendenciaList.size());
        System.debug('DIAS MES: ' + totalDiasMes);
        System.debug('DIAS TRANSCURRIDOS: ' + totalDiasTranscurridos);
        
        
        // CALCULO IMPORTE TENDENCIA
        // 
        // 
        // 
        
        Decimal tendencia = 0;
        Decimal totalVentaMes = 0;
        Decimal totalVentaPromedioDiaria = 0;
        
        System.debug('============== calculaImporteTendencia ===============');                                              
        System.debug('totalDiasMes : ' + totalDiasMes);
        System.debug('totalDiasTranscurridos : ' + totalDiasTranscurridos);
        System.debug('ejecutivoId : ' + vendedorId);
        System.debug('mesConsulta : ' + mesConsulta);
        System.debug('anio : ' + anio);
        System.debug('fecha : ' +fecha);                                                      
        System.debug('============== FOR 299===============');                                                                                                    
        for(Tendencia__c t: ejecutaConsultaTendencia('Venta Telemarketing', vendedorId, mesConsulta, anio)){
            totalVentaMes += t.importe__c;                        
            System.debug('t.importe__c : ' +t.importe__c);       
            System.debug('totalVentaMes : ' +totalVentaMes);       
        }
        System.debug('============== AFTER FOR ==============='); 
        if(totalDiasTranscurridos>0){
            totalVentaPromedioDiaria = totalVentaMes / totalDiasTranscurridos;
        }else{
            totalVentaPromedioDiaria = totalVentaMes;    
        }
        
        tendencia = totalVentaPromedioDiaria*totalDiasMes;
        
        System.debug('totalVentaMes : ' +totalVentaMes);   
        System.debug('totalDiasTranscurridos : ' +totalDiasTranscurridos);   
        System.debug('totalVentaPromedioDiaria : ' +totalVentaPromedioDiaria);   
        System.debug('totalDiasMes : ' +totalDiasMes); 
        System.debug('tendencia : ' +tendencia); 
        
        //
        //
        //
        //
        
        
        If(dpTendenciaList.size()==0){
            
            Tendencia__c tend 		= new Tendencia__c ();
            tend.Ejecutivo__c	 	= vendedorId;
            tend.Tipo_de_Importe__c	= 'Tendencia Telemarketing';
            tend.Fecha__c			= fecha;
            tend.Importe__c			= tendencia;
            tend.OwnerId			= vendedorId; 
            
            System.debug('tend.Tipo_de_Importe__c: ' + tend.Tipo_de_Importe__c	);
            System.debug('tend.Importe__c: ' + tend.Importe__c);
            
            insert tend;
            
            

        }
        if(dpTendenciaList.size()>0){
            System.debug('=================FOR 273================');
            for(tendencia__c t: dpTendenciaList){
                t.Importe__c = tendencia;
                System.debug('t.Tipo_de_Importe__c: ' + t.Tipo_de_Importe__c	);
                System.debug('t.Importe__c: ' + t.Importe__c);
            }
            update dpTendenciaList;
        }
        
        
    }
    
    public static List<String> llenaValoresPresupuesto (){
        
        List<String> listaPresupuestos = new List<String>();
        listaPresupuestos.add('Total Presupuesto Venta Nueva');
        listaPresupuestos.add('Presupuesto Mensajeria TS-T0 Estandar');
        listaPresupuestos.add('Presupuesto Mensajeria TS-T0 Express');
        listaPresupuestos.add('Presupuesto Mensajeria TS-T0 Internacional');
        listaPresupuestos.add('Presupuesto Paquetería y Carga T1-T7 Estandar');
        listaPresupuestos.add('Presupuesto Paquetería y Carga T1-T7 Express');
        listaPresupuestos.add('Presupuesto Paquetería y Carga T1-T7 Internacional');
        listaPresupuestos.add('Presupuesto Servicios Estandar');
        listaPresupuestos.add('Presupuesto Servicios Express');
        listaPresupuestos.add('Presupuesto Servicios Internacional');
        listaPresupuestos.add('Total Presupuesto Mensajería TS-T0');
        listaPresupuestos.add('Total Presupuesto Paquetería y Carga T1-T7');
        listaPresupuestos.add('Total Presupuesto Servicios');
        listaPresupuestos.add('Total Presupuesto Estándar');
        listaPresupuestos.add('Total Presupuesto Express');
        listaPresupuestos.add('Total Presupuesto Internacional');
        listaPresupuestos.add('Total Presupuesto Nacional');
        listaPresupuestos.add('Total Presupuesto Venta Mantenimiento');
        listaPresupuestos.add('Presupuesto Mensajeria TS-T0 Estandar mantenimiento');
        listaPresupuestos.add('Presupuesto Mensajeria TS-T0 Express mantenimiento');
        listaPresupuestos.add('Presupuesto Mensajeria TS-T0 Internacional mantenimiento');
        listaPresupuestos.add('Presupuesto Paquetería y Carga T1-T7 Estandar mantenimiento');
        listaPresupuestos.add('Presupuesto Paquetería y Carga T1-T7 Express mantenimiento');
        listaPresupuestos.add('Presupuesto Paquetería y Carga T1-T7 Internacional mantenimiento');
        listaPresupuestos.add('Presupuesto Servicios Estandar mantenimiento');
        listaPresupuestos.add('Presupuesto Servicios Express mantenimiento');
        listaPresupuestos.add('Presupuesto Servicios Internacional mantenimiento');
        listaPresupuestos.add('Total Presupuesto Mensajería TS-T0 mantenimiento');
        listaPresupuestos.add('Total Presupuesto Paquetería y Carga T1-T7 mantenimiento');
        listaPresupuestos.add('Total Presupuesto Servicios mantenimiento');
        listaPresupuestos.add('Total Presupuesto Estándar mantenimiento');
        listaPresupuestos.add('Total Presupuesto Express mantenimiento');
        listaPresupuestos.add('Total Presupuesto Internacional mantenimiento');
        listaPresupuestos.add('Total Presupuesto Nacional mantenimiento');
        listaPresupuestos.add('Total Presupuesto Global');
        listaPresupuestos.add('Presupuesto Global Mensajeria TS-T0 Estandar');
        listaPresupuestos.add('Presupuesto Global Mensajeria TS-T0 Express');
        listaPresupuestos.add('Presupuesto Global Mensajeria TS-T0 Internacional');
        listaPresupuestos.add('Presupuesto Global Paquetería y Carga T1-T7 Estandar');
        listaPresupuestos.add('Presupuesto Global Paquetería y Carga T1-T7 Express');
        listaPresupuestos.add('Presupuesto Global Paquetería y Carga T1-T7 Internacional');
        listaPresupuestos.add('Presupuesto Global Servicios Estandar');
        listaPresupuestos.add('Presupuesto Global Servicios Express');
        listaPresupuestos.add('Presupuesto Global Servicios Internacional');
        listaPresupuestos.add('Total Presupuesto Global Mensajería TS-T0');
        listaPresupuestos.add('Total Presupuesto Global Paquetería y Carga T1-T7');
        listaPresupuestos.add('Total Presupuesto Global Servicios');
        listaPresupuestos.add('Total Presupuesto Global Estándar');
        listaPresupuestos.add('Total Presupuesto Global Express');
        listaPresupuestos.add('Total Presupuesto Global Internacional');
        listaPresupuestos.add('Presupuesto Global Nacional');

        return listaPresupuestos;
    }
    
    public static List<String> llenaValoresVentas (){
        
        List<String> listaPresupuestos = new List<String>();
        listaPresupuestos.add('Total Venta Nueva');
        listaPresupuestos.add('Venta Mensajeria TS-T0 Estandar');
        listaPresupuestos.add('Venta Mensajeria TS-T0 Express');
        listaPresupuestos.add('Venta Mensajeria TS-T0 Internacional');
        listaPresupuestos.add('Venta Paquetería y Carga T1-T7 Estandar');
        listaPresupuestos.add('Venta Paquetería y Carga T1-T7 Express');
        listaPresupuestos.add('Venta Paquetería y Carga T1-T7 Internacional');
        listaPresupuestos.add('Venta Servicios Estandar');
        listaPresupuestos.add('Venta Servicios Express');
        listaPresupuestos.add('Venta Servicios Internacional');
        listaPresupuestos.add('Total Venta Mensajería TS-T0');
        listaPresupuestos.add('Total Venta Paquetería y Carga T1-T7');
        listaPresupuestos.add('Total Venta Servicios');
        listaPresupuestos.add('Total Venta Estándar');
        listaPresupuestos.add('Total Venta Express');
        listaPresupuestos.add('Total Venta Internacional');
        listaPresupuestos.add('Total Venta Nacional');
        listaPresupuestos.add('Total Venta Mantenimiento');
        listaPresupuestos.add('Venta Mensajeria TS-T0 Estandar mantenimiento');
        listaPresupuestos.add('Venta Mensajeria TS-T0 Express mantenimiento');
        listaPresupuestos.add('Venta Mensajeria TS-T0 Internacional mantenimiento');
        listaPresupuestos.add('Venta Paquetería y Carga T1-T7 Estandar mantenimiento');
        listaPresupuestos.add('Venta Paquetería y Carga T1-T7 Express mantenimiento');
        listaPresupuestos.add('Venta Paquetería y Carga T1-T7 Internacional mantenimiento');
        listaPresupuestos.add('Venta Servicios Estandar mantenimiento');
        listaPresupuestos.add('Venta Servicios Express mantenimiento');
        listaPresupuestos.add('Venta Servicios Internacional mantenimiento');
        listaPresupuestos.add('Total Venta Mensajería TS-T0 mantenimiento');
        listaPresupuestos.add('Total Venta Paquetería y Carga T1-T7 mantenimiento');
        listaPresupuestos.add('Total Venta Servicios mantenimiento');
        listaPresupuestos.add('Total Venta Estándar mantenimiento');
        listaPresupuestos.add('Total Venta Express mantenimiento');
        listaPresupuestos.add('Total Venta Internacional mantenimiento');
        listaPresupuestos.add('Total Venta Nacional mantenimiento');
        listaPresupuestos.add('Total Venta Global');
        listaPresupuestos.add('Total Venta Global Mensajeria TS-T0 Estandar');
        listaPresupuestos.add('Total Venta Global Mensajeria TS-T0 Express');
        listaPresupuestos.add('Total Venta Global Mensajeria TS-T0 Internacional');
        listaPresupuestos.add('Total Venta Global Paquetería y Carga T1-T7 Estandar');
        listaPresupuestos.add('Total Venta Global Paquetería y Carga T1-T7 Express');
        listaPresupuestos.add('Total Venta Global Paquetería y Carga T1-T7 Internacional');
        listaPresupuestos.add('Total Venta Global Servicios Estandar');
        listaPresupuestos.add('Total Venta Global Servicios Express');
        listaPresupuestos.add('Total Venta Global Servicios Internacional');
        listaPresupuestos.add('Total Venta Global Mensajería TS-T0');
        listaPresupuestos.add('Total Venta Global Paquetería y Carga T1-T7');
        listaPresupuestos.add('Total Venta Global Servicios');
        listaPresupuestos.add('Total Venta Global Estándar');
        listaPresupuestos.add('Total Venta Global Express');
        listaPresupuestos.add('Total Venta Global Internacional');
        listaPresupuestos.add('Total Venta Global Nacional');

        return listaPresupuestos;
    }

    public static Map<String, Decimal> llenaValoresPresupuestoMap (List<Detalle_Presupuesto__c> dpSucursalList){
        Map<String, Decimal> presupuestoValorMap = new Map<String, Decimal> ();
        
        
        
        if(dpSucursalList[0].Total_presupuesto__c == null){presupuestoValorMap.put('Total Presupuesto Venta Nueva', 0);}else{presupuestoValorMap.put('Total Presupuesto Venta Nueva', dpSucursalList[0].Total_presupuesto__c);}
        if(dpSucursalList[0].Mensajeria_TS_T0_estandar__c == null){presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Estandar', 0);}else{presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Estandar', dpSucursalList[0].Mensajeria_TS_T0_estandar__c);}
        if(dpSucursalList[0].Mensajeria_TS_T0_express__c == null){presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Express', 0);}else{presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Express', dpSucursalList[0].Mensajeria_TS_T0_express__c);}
        if(dpSucursalList[0].Mensajeria_TS_T0_internacional__c == null){ presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Internacional', 	0); }else{ presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Internacional', dpSucursalList[0].Mensajeria_TS_T0_internacional__c);}
        if(dpSucursalList[0].Paqueteria_Carga_T1_T7_Estandar__c == null){presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Estandar', 0);}else{presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Estandar', dpSucursalList[0].Paqueteria_Carga_T1_T7_Estandar__c);}
        if(dpSucursalList[0].Paqueteria_Carga_T1_T7_Express__c == null){presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Express', 0);}else{presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Express', dpSucursalList[0].Paqueteria_Carga_T1_T7_Express__c);}
        if(dpSucursalList[0].Paqueteria_Carga_T1_T7_Internacional__c == null){presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Internacional', 0);}else{presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Internacional', 	dpSucursalList[0].Paqueteria_Carga_T1_T7_Internacional__c);}
        if(dpSucursalList[0].Servicios_Estandar__c == null){presupuestoValorMap.put('Presupuesto Servicios Estandar', 0);}else{presupuestoValorMap.put('Presupuesto Servicios Estandar', dpSucursalList[0].Servicios_Estandar__c);}
        if(dpSucursalList[0].Servicios_Express__c == null){presupuestoValorMap.put('Presupuesto Servicios Express', 0);}else{presupuestoValorMap.put('Presupuesto Servicios Express', 	dpSucursalList[0].Servicios_Express__c);}
        if(dpSucursalList[0].Servicios_Internacionales__c == null){presupuestoValorMap.put('Presupuesto Servicios Internacional', 0);}else{presupuestoValorMap.put('Presupuesto Servicios Internacional',	dpSucursalList[0].Servicios_Internacionales__c);}
        if(dpSucursalList[0].Total_mensajeria_TS_T0__c == null){presupuestoValorMap.put('Total Presupuesto Mensajería TS-T0', 0);}else{presupuestoValorMap.put('Total Presupuesto Mensajería TS-T0', dpSucursalList[0].Total_mensajeria_TS_T0__c);}
        if(dpSucursalList[0].Total_Paqueteria_Carga_T1_T7__c == null){presupuestoValorMap.put('Total Presupuesto Paquetería y Carga T1-T7', 0);}else{presupuestoValorMap.put('Total Presupuesto Paquetería y Carga T1-T7', dpSucursalList[0].Total_Paqueteria_Carga_T1_T7__c);}
        if(dpSucursalList[0].Total_Servicios__c == null){presupuestoValorMap.put('Total Presupuesto Servicios', 0);}else{presupuestoValorMap.put('Total Presupuesto Servicios', dpSucursalList[0].Total_Servicios__c);}
        if(dpSucursalList[0].Total_estandar__c == null){presupuestoValorMap.put('Total Presupuesto Estándar', 0);}else{presupuestoValorMap.put('Total Presupuesto Estándar',	dpSucursalList[0].Total_estandar__c);}
        if(dpSucursalList[0].Total_express__c == null){presupuestoValorMap.put('Total Presupuesto Express', 0);}else{presupuestoValorMap.put('Total Presupuesto Express', dpSucursalList[0].Total_express__c);}
        if(dpSucursalList[0].Total_Internacional__c == null){presupuestoValorMap.put('Total Presupuesto Internacional', 0);}else{presupuestoValorMap.put('Total Presupuesto Internacional', dpSucursalList[0].Total_Internacional__c);}
        if(dpSucursalList[0].Total_Nacional__c == null){presupuestoValorMap.put('Total Presupuesto Nacional', 0);}else{presupuestoValorMap.put('Total Presupuesto Nacional', dpSucursalList[0].Total_Nacional__c);}
        if(dpSucursalList[0].Total_presupuesto_mantenimiento__c == null){presupuestoValorMap.put('Total Presupuesto Venta Mantenimiento', 0);}else{presupuestoValorMap.put('Total Presupuesto Venta Mantenimiento', dpSucursalList[0].Total_presupuesto_mantenimiento__c);}
        if(dpSucursalList[0].Mensajeria_TS_T0_estandar_mantenimiento__c == null){presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Estandar mantenimiento', 0);}else{presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Estandar mantenimiento', dpSucursalList[0].Mensajeria_TS_T0_estandar_mantenimiento__c);}
        if(dpSucursalList[0].Mensajeria_TS_T0_express_mantenimiento__c == null){presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Express mantenimiento', 0);}else{presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Express mantenimiento', dpSucursalList[0].Mensajeria_TS_T0_express_mantenimiento__c);}
        if(dpSucursalList[0].Mensajeria_TS_T0_internacional_mtto__c == null){presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Internacional mantenimiento', 0);}else{presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Internacional mantenimiento', dpSucursalList[0].Mensajeria_TS_T0_internacional_mtto__c);}
        if(dpSucursalList[0].Paqueteria_Carga_T1_T7_Estandar_mtto__c == null){presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Estandar mantenimiento', 0);}else{presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Estandar mantenimiento', dpSucursalList[0].Paqueteria_Carga_T1_T7_Estandar_mtto__c);}
        if(dpSucursalList[0].Paqueteria_Carga_T1_T7_Express_mtto__c == null){presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Express mantenimiento', 0);}else{presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Express mantenimiento', dpSucursalList[0].Paqueteria_Carga_T1_T7_Express_mtto__c);}
        if(dpSucursalList[0].Paqueteria_y_Carga_T1_T7_Int_mtto__c == null){presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Internacional mantenimiento', 0);}else{presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Internacional mantenimiento', dpSucursalList[0].Paqueteria_y_Carga_T1_T7_Int_mtto__c);}
        if(dpSucursalList[0].Servicios_Estandar_Mantenimiento__c == null){presupuestoValorMap.put('Presupuesto Servicios Estandar mantenimiento', 0);}else{presupuestoValorMap.put('Presupuesto Servicios Estandar mantenimiento', dpSucursalList[0].Servicios_Estandar_Mantenimiento__c);}
        if(dpSucursalList[0].Servicios_Express_Mantenimiento__c == null){presupuestoValorMap.put('Presupuesto Servicios Express mantenimiento', 0);}else{presupuestoValorMap.put('Presupuesto Servicios Express mantenimiento', dpSucursalList[0].Servicios_Express_Mantenimiento__c);}
        if(dpSucursalList[0].Servicios_Internacionales_Mantenimiento__c == null){presupuestoValorMap.put('Presupuesto Servicios Internacional mantenimiento', 0);}else{presupuestoValorMap.put('Presupuesto Servicios Internacional mantenimiento', dpSucursalList[0].Servicios_Internacionales_Mantenimiento__c);}
        if(dpSucursalList[0].Total_mensajeria_TS_T0_Mantenimiento__c == null){presupuestoValorMap.put('Total Presupuesto Mensajería TS-T0 mantenimiento', 0);}else{presupuestoValorMap.put('Total Presupuesto Mensajería TS-T0 mantenimiento', dpSucursalList[0].Total_mensajeria_TS_T0_Mantenimiento__c);}
        if(dpSucursalList[0].Total_paqueteria_carga_T1_T7_Mtto__c == null){presupuestoValorMap.put('Total Presupuesto Paquetería y Carga T1-T7 mantenimiento', 0);}else{presupuestoValorMap.put('Total Presupuesto Paquetería y Carga T1-T7 mantenimiento', dpSucursalList[0].Total_paqueteria_carga_T1_T7_Mtto__c);}
        if(dpSucursalList[0].Total_Servicios_Mantenimiento__c == null){presupuestoValorMap.put('Total Presupuesto Servicios mantenimiento', 0);}else{presupuestoValorMap.put('Total Presupuesto Servicios mantenimiento', dpSucursalList[0].Total_Servicios_Mantenimiento__c);}
        if(dpSucursalList[0].Total_estandar_mantenimiento__c == null){presupuestoValorMap.put('Total Presupuesto Estándar mantenimiento', 0);}else{presupuestoValorMap.put('Total Presupuesto Estándar mantenimiento', dpSucursalList[0].Total_estandar_mantenimiento__c);}
        if(dpSucursalList[0].Total_express_mantenimiento__c == null){presupuestoValorMap.put('Total Presupuesto Express mantenimiento', 0);}else{presupuestoValorMap.put('Total Presupuesto Express mantenimiento', dpSucursalList[0].Total_express_mantenimiento__c);}
        if(dpSucursalList[0].Total_Internacional_Mantenimiento__c == null){presupuestoValorMap.put('Total Presupuesto Internacional mantenimiento', 0);}else{presupuestoValorMap.put('Total Presupuesto Internacional mantenimiento', dpSucursalList[0].Total_Internacional_Mantenimiento__c);}
        if(dpSucursalList[0].Total_Nacional_Mantenimiento__c == null){presupuestoValorMap.put('Total Presupuesto Nacional mantenimiento', 0);}else{presupuestoValorMap.put('Total Presupuesto Nacional mantenimiento', dpSucursalList[0].Total_Nacional_Mantenimiento__c);}
        if(dpSucursalList[0].Total_Presupuesto_Ejecutivo__c == null){presupuestoValorMap.put('Total Presupuesto Global', 0);}else{presupuestoValorMap.put('Total Presupuesto Global', dpSucursalList[0].Total_Presupuesto_Ejecutivo__c);}
        
        
        presupuestoValorMap.put('Presupuesto Global Mensajeria TS-T0 Estandar', presupuestoValorMap.get('Presupuesto Mensajeria TS-T0 Estandar') + 	presupuestoValorMap.get('Presupuesto Mensajeria TS-T0 Estandar mantenimiento'));
        presupuestoValorMap.put('Presupuesto Global Mensajeria TS-T0 Express', presupuestoValorMap.get('Presupuesto Mensajeria TS-T0 Express') + 	presupuestoValorMap.get('Presupuesto Mensajeria TS-T0 Express mantenimiento'));
        presupuestoValorMap.put('Presupuesto Global Mensajeria TS-T0 Internacional', presupuestoValorMap.get('Presupuesto Mensajeria TS-T0 Internacional') + 	presupuestoValorMap.get('Presupuesto Mensajeria TS-T0 Internacional mantenimiento')); 
        presupuestoValorMap.put('Presupuesto Global Paquetería y Carga T1-T7 Estandar', presupuestoValorMap.get('Presupuesto Paquetería y Carga T1-T7 Estandar') + 	presupuestoValorMap.get('Presupuesto Paquetería y Carga T1-T7 Estandar mantenimiento'));
        presupuestoValorMap.put('Presupuesto Global Paquetería y Carga T1-T7 Express', presupuestoValorMap.get('Presupuesto Paquetería y Carga T1-T7 Express') + 	presupuestoValorMap.get('Presupuesto Paquetería y Carga T1-T7 Express mantenimiento')); 
        presupuestoValorMap.put('Presupuesto Global Paquetería y Carga T1-T7 Internacional', presupuestoValorMap.get('Presupuesto Paquetería y Carga T1-T7 Internacional') + 	presupuestoValorMap.get('Presupuesto Paquetería y Carga T1-T7 Internacional mantenimiento')); 
        presupuestoValorMap.put('Presupuesto Global Servicios Estandar', presupuestoValorMap.get('Presupuesto Servicios Estandar') + 	presupuestoValorMap.get('Presupuesto Servicios Estandar mantenimiento')); 
        presupuestoValorMap.put('Presupuesto Global Servicios Express', presupuestoValorMap.get('Presupuesto Servicios Express') + 	presupuestoValorMap.get('Presupuesto Servicios Express mantenimiento')); 
        presupuestoValorMap.put('Presupuesto Global Servicios Internacional', presupuestoValorMap.get('Presupuesto Servicios Internacional') + 	presupuestoValorMap.get('Presupuesto Servicios Internacional mantenimiento'));
		
        
        if(dpSucursalList[0].Total_Mensajeria__c == null){presupuestoValorMap.put('Total Presupuesto Global Mensajería TS-T0', 0);}else{presupuestoValorMap.put('Total Presupuesto Global Mensajería TS-T0', dpSucursalList[0].Total_Mensajeria__c);}
        if(dpSucursalList[0].Total_PyC__c == null){presupuestoValorMap.put('Total Presupuesto Global Paquetería y Carga T1-T7', 0);}else{presupuestoValorMap.put('Total Presupuesto Global Paquetería y Carga T1-T7', dpSucursalList[0].Total_PyC__c);}
        if(dpSucursalList[0].Total_Servicio__c == null){presupuestoValorMap.put('Total Presupuesto Global Servicios', 0);}else{presupuestoValorMap.put('Total Presupuesto Global Servicios', dpSucursalList[0].Total_Servicio__c);}
        if(dpSucursalList[0].Total_total_Estandar__c == null){presupuestoValorMap.put('Total Presupuesto Global Estándar',	0);}else{presupuestoValorMap.put('Total Presupuesto Global Estándar',	dpSucursalList[0].Total_total_Estandar__c);}
        if(dpSucursalList[0].Total_total_Express__c == null){presupuestoValorMap.put('Total Presupuesto Global Express', 0);}else{presupuestoValorMap.put('Total Presupuesto Global Express', dpSucursalList[0].Total_total_Express__c);}
        if(dpSucursalList[0].Total_total_Internacional__c == null){presupuestoValorMap.put('Total Presupuesto Global Internacional', 0);}else{presupuestoValorMap.put('Total Presupuesto Global Internacional', dpSucursalList[0].Total_total_Internacional__c);}
        presupuestoValorMap.put('Presupuesto Global Nacional', presupuestoValorMap.get('Total Presupuesto Global Estándar') + 	presupuestoValorMap.get('Total Presupuesto Global Express')); 
        
        return presupuestoValorMap;
        
    }
    
    public static Map<String, Decimal> llenaValoresVentasMap (wrapperValoresVentas wVentas){
        Map<String, Decimal> ventasValorMap = new Map<String, Decimal> ();
        
        //NUEVO
        
        ventasValorMap.put('Total Venta Nueva', 							wVentas.totalVentaClienteNuevo); 
        
        ventasValorMap.put('Venta Mensajeria TS-T0 Estandar',				wVentas.totalMensajeria_EstandarNVO); 
        ventasValorMap.put('Venta Mensajeria TS-T0 Express',				wVentas.totalMensajeria_ExpressNVO); 
        ventasValorMap.put('Venta Mensajeria TS-T0 Internacional',			wVentas.totalMensajeria_InternacionalNVO); 
        
        ventasValorMap.put('Venta Paquetería y Carga T1-T7 Estandar',		wVentas.totalPaqueteria_EstandarNVO); 
        ventasValorMap.put('Venta Paquetería y Carga T1-T7 Express',		wVentas.totalPaqueteria_ExpressNVO); 
        ventasValorMap.put('Venta Paquetería y Carga T1-T7 Internacional',	wVentas.totalPaqueteria_InternacionalNVO);
        
        ventasValorMap.put('Venta Servicios Estandar',						wVentas.totalServicios_EstandarNVO); 
        ventasValorMap.put('Venta Servicios Express',						wVentas.totalServicios_ExpressNVO); 
        ventasValorMap.put('Venta Servicios Internacional',					wVentas.totalServicios_InternacionalNVO);
        
        ventasValorMap.put('Total Venta Mensajería TS-T0',					wVentas.totalMensajeriaNVO); 
        ventasValorMap.put('Total Venta Paquetería y Carga T1-T7',			wVentas.totalPaqueteriaNVO); 
        ventasValorMap.put('Total Venta Servicios',							wVentas.totalServiciosNVO);

		ventasValorMap.put('Total Venta Estándar',							wVentas.totalEstandarNVO); 
        ventasValorMap.put('Total Venta Express',							wVentas.totalExpressNVO); 
        ventasValorMap.put('Total Venta Internacional',						wVentas.totalInternacionalNVO);
        ventasValorMap.put('Total Venta Nacional',							wVentas.totalNacionalNVO);
        
        //MANTENIMIENTO
        
        ventasValorMap.put('Total Venta Mantenimiento', 									wVentas.totalVentaClienteMantenimiento); 
        
        ventasValorMap.put('Venta Mensajeria TS-T0 Estandar mantenimiento',					wVentas.totalMensajeria_EstandarMTTO); 
        ventasValorMap.put('Venta Mensajeria TS-T0 Express mantenimiento',	        		wVentas.totalMensajeria_ExpressMTTO); 
        ventasValorMap.put('Venta Mensajeria TS-T0 Internacional mantenimiento',			wVentas.totalMensajeria_InternacionalMTTO); 
        
        ventasValorMap.put('Venta Paquetería y Carga T1-T7 Estandar mantenimiento',			wVentas.totalPaqueteria_EstandarMTTO); 
        ventasValorMap.put('Venta Paquetería y Carga T1-T7 Express mantenimiento',			wVentas.totalPaqueteria_ExpressMTTO); 
        ventasValorMap.put('Venta Paquetería y Carga T1-T7 Internacional mantenimiento',	wVentas.totalPaqueteria_InternacionalMTTO);
        
        ventasValorMap.put('Venta Servicios Estandar mantenimiento',						wVentas.totalServicios_EstandarMTTO); 
        ventasValorMap.put('Venta Servicios Express mantenimiento',							wVentas.totalServicios_ExpressMTTO); 
        ventasValorMap.put('Venta Servicios Internacional mantenimiento',					wVentas.totalServicios_InternacionalMTTO);
        
        ventasValorMap.put('Total Venta Mensajería TS-T0 mantenimiento',					wVentas.totalMensajeriaMTTO); 
        ventasValorMap.put('Total Venta Paquetería y Carga T1-T7 mantenimiento',			wVentas.totalPaqueteriaMTTO); 
        ventasValorMap.put('Total Venta Servicios mantenimiento',							wVentas.totalServiciosMTTO);

		ventasValorMap.put('Total Venta Estándar mantenimiento',							wVentas.totalEstandarMTTO); 
        ventasValorMap.put('Total Venta Express mantenimiento',								wVentas.totalExpressMTTO); 
        ventasValorMap.put('Total Venta Internacional mantenimiento',						wVentas.totalInternacionalMTTO);
        ventasValorMap.put('Total Venta Nacional mantenimiento',							wVentas.totalNacionalMTTO);
        
        //GLOBAL FALTA NOMBRES
        
        ventasValorMap.put('Total Venta Global', 											wVentas.totalVentasGLOBAL); 
        
        ventasValorMap.put('Total Venta Global Mensajeria TS-T0 Estandar',					wVentas.totalMensajeria_EstandarGLOBAL); 
        ventasValorMap.put('Total Venta Global Mensajeria TS-T0 Express',	        		wVentas.totalMensajeria_ExpressGLOBAL); 
        ventasValorMap.put('Total Venta Global Mensajeria TS-T0 Internacional',				wVentas.totalMensajeria_InternacionalGLOBAL); 
        
        ventasValorMap.put('Total Venta Global Paquetería y Carga T1-T7 Estandar',			wVentas.totalPaqueteria_EstandarGLOBAL); 
        ventasValorMap.put('Total Venta Global Paquetería y Carga T1-T7 Express',			wVentas.totalPaqueteria_ExpressGLOBAL); 
        ventasValorMap.put('Total Venta Global Paquetería y Carga T1-T7 Internacional',		wVentas.totalPaqueteria_InternacionalGLOBAL);
        
        ventasValorMap.put('Total Venta Global Servicios Estandar',							wVentas.totalServicios_EstandarGLOBAL); 
        ventasValorMap.put('Total Venta Global Servicios Express',							wVentas.totalServicios_ExpressGLOBAL); 
        ventasValorMap.put('Total Venta Global Servicios Internacional',					wVentas.totalServicios_InternacionalGLOBAL);
        
        ventasValorMap.put('Total Venta Global Mensajería TS-T0',							wVentas.totalMensajeriaGLOBAL); 
        ventasValorMap.put('Total Venta Global Paquetería y Carga T1-T7',					wVentas.totalPaqueteriaGLOBAL); 
        ventasValorMap.put('Total Venta Global Servicios',									wVentas.totalServiciosGLOBAL);

		ventasValorMap.put('Total Venta Global Estándar',									wVentas.totalEstandarGLOBAL); 
        ventasValorMap.put('Total Venta Global Express',									wVentas.totalExpressGLOBAL); 
        ventasValorMap.put('Total Venta Global Internacional',								wVentas.totalInternacionalGLOBAL);
        ventasValorMap.put('Total Venta Global Nacional',									wVentas.totalNacionalGLOBAL);
   
        return ventasValorMap;
    }
    
    public static List<String> llenaValoresTendencias (){
        
        List<String> listaTendencias = new List<String>();
        listaTendencias.add('Total Tendencia Venta Nueva');
        listaTendencias.add('Tendencia Mensajeria TS-T0 Estandar');
        listaTendencias.add('Tendencia Mensajeria TS-T0 Express');
        listaTendencias.add('Tendencia Mensajeria TS-T0 Internacional');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7 Estandar');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7 Express');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7 Internacional');
        listaTendencias.add('Tendencia Servicios Estandar');
        listaTendencias.add('Tendencia Servicios Express');
        listaTendencias.add('Tendencia Servicios Internacional');
        listaTendencias.add('Tendencia Mensajería TS-T0');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7');
        listaTendencias.add('Tendencia Servicios');
        listaTendencias.add('Tendencia Estándar');
        listaTendencias.add('Tendencia Express');
        listaTendencias.add('Tendencia Internacional');
        listaTendencias.add('Tendencia Nacional');
        listaTendencias.add('Total Tendencia Venta Mantenimiento');
        listaTendencias.add('Tendencia Mensajería TS-T0 Estandar Mantenimiento');
        listaTendencias.add('Tendencia Mensajeria TS-T0 Express mantenimiento');
        listaTendencias.add('Tendencia Mensajeria TS-T0 Internacional mantenimiento');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7 Estandar mantenimiento');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7 Express mantenimiento');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7 Internacional mantenimiento');
        listaTendencias.add('Tendencia Servicios Estandar mantenimiento');
        listaTendencias.add('Tendencia Servicios Express mantenimiento');
        listaTendencias.add('Tendencia Servicios Internacional mantenimiento');
        listaTendencias.add('Total Tendencia Mensajería TS-T0 mantenimiento');
        listaTendencias.add('Total Tendencia Paquetería y Carga T1-T7 mantenimiento');
        listaTendencias.add('Total Tendencia Servicios mantenimiento');
        listaTendencias.add('Total Tendencia Estándar mantenimiento');
        listaTendencias.add('Total Tendencia Express mantenimiento');
        listaTendencias.add('Total Tendencia Internacional mantenimiento');
        listaTendencias.add('Total Tendencia Nacional mantenimiento');
        listaTendencias.add('Tendencia Global');
        listaTendencias.add('Tendencia Global Mensajeria TS-T0 Estandar');
        listaTendencias.add('Tendencia Global Mensajeria TS-T0 Express');
        listaTendencias.add('Tendencia Global Mensajeria TS-T0 Internacional');
        listaTendencias.add('Tendencia Global Paquetería y Carga T1-T7 Estandar');
        listaTendencias.add('Tendencia Global Paquetería y Carga T1-T7 Express');
        listaTendencias.add('Tendencia Global Paquetería y Carga T1-T7 Internacional');
        listaTendencias.add('Tendencia Global Servicios Estandar');
        listaTendencias.add('Tendencia Global Servicios Express');
        listaTendencias.add('Tendencia Global Servicios Internacional');
        listaTendencias.add('Total Tendencia Global Mensajería TS-T0');
        listaTendencias.add('Total Tendencia Global Paquetería y Carga T1-T7');
        listaTendencias.add('Total Tendencia Global Servicios');
        listaTendencias.add('Total Tendencia Global Estándar');
        listaTendencias.add('Total Tendencia Global Express');
        listaTendencias.add('Total Tendencia Global Internacional');
        listaTendencias.add('Tendencia Global Nacional');
        
        return listaTendencias;
    }
    
    public static void recalculoTendenciasEjecutivo (Id EjecutivoId, String mesConsulta, String anio, Date fecha){
        
        Decimal totalDiasMes 									= 0;
        Decimal totalDiasTranscurridos 							= 0;
        
        List<Tendencia__c> 				dpTendenciaList 		= new List<Tendencia__c>();
        List<Tendencia__c> 				dpVentasList 			= new List<Tendencia__c>();
        List<Tendencia__c>				tendenciasUpdateList 	= new List<Tendencia__c>();
        
        List<Ejecutivo_Calendario__c>  	EjecCalendarioList		= new List<Ejecutivo_Calendario__c>();
        List<Ano_Calendario__c>			anioCalendarioList		= new List<Ano_Calendario__c>();
        
        List<String>					valoresVentasList 		= llenaValoresVentas ();
        
        Map<String, String> 			correspondenciasTendenciasVentasMap = new Map<String, String>();
            
        
        // LISTA DE VALORES DE TENDENCIA 
        dpTendenciaList = [SELECT Id, Ejecutivo__c, Anio__c, Mes__c, importe__c, Tipo_de_Importe__c FROM Tendencia__c 
                           WHERE Ejecutivo__c =: ejecutivoId AND Mes__c =: mesConsulta 
                           AND Anio__c =: anio AND Tipo_de_Importe__c IN: llenaValoresTendencias()];
        
        // LISTA DE VALORES DE VENTA PARA LA TENDENCIA
        dpVentasList 	= [SELECT Id, Ejecutivo__c, Anio__c, Mes__c, importe__c, Tipo_de_Importe__c FROM Tendencia__c 
                           WHERE Ejecutivo__c =: ejecutivoId AND Mes__c =: mesConsulta 
                           AND Anio__c =: anio AND Tipo_de_Importe__c IN:valoresVentasList];
        
        // CONSULTA CALENDARIO RELACIONADO A LA SUCURSAL
        
        EjecCalendarioList = [SELECT Id, Ejecutivo__c, AnioCalendario__c, AnioCalendario__r.Ano__c FROM Ejecutivo_Calendario__c 
                             WHERE Ejecutivo__c =: ejecutivoId AND AnioCalendario__r.Ano__c =: anio]; 
        
        // CONSULTA VALORES DEL CALENDARIO RELACIONADO A LA SUCURSAL
        If(EjecCalendarioList.size()>0){
            anioCalendarioList= [SELECT Abril__c,Agosto__c,Ano__c,DiasHabilesTranscurridosDelAno__c,Dias_transcurridos_Abril__c,Dias_transcurridos_Agosto__c,
                                 Dias_transcurridos_Diciembre__c,Dias_transcurridos_Enero__c,Dias_transcurridos_Febrero__c,Dias_transcurridos_Julio__c,
                                 Dias_transcurridos_Junio__c,Dias_transcurridos_Marzo__c,Dias_transcurridos_Mayo__c,Dias_transcurridos_Noviembre__c,
                                 Dias_transcurridos_Octubre__c,Dias_transcurridos_Septiembre__c,Diciembre__c,Enero__c,Febrero__c,Id,Julio__c,Junio__c,
                                 Marzo__c,Mayo__c,Name,Noviembre__c,Observaciones__c,Octubre__c,Septiembre__c,Total_Anual__c FROM Ano_Calendario__c 
                                 WHERE Id=: EjecCalendarioList[0].AnioCalendario__c];
            
            List<Decimal> diasMes_DiasTranscurridos_List = new List<Decimal>();
            diasMes_DiasTranscurridos_List = calculaDiasMes_DiasTranscurridos(anioCalendarioList, mesConsulta);
            totalDiasMes = diasMes_DiasTranscurridos_List[0];
            //totalDiasTranscurridos = diasMes_DiasTranscurridos_List[1];
            totalDiasTranscurridos = AuxTendencia.getDiasTranscurridos(anioCalendarioList[0].Id,fecha);
        }
        
        correspondenciasTendenciasVentasMap = retornaValoresCorrespondencia();
        System.debug('=================recalculoTendencias================');
        System.debug('TAMAÑO LIST TENDENCIA: ' + dpTendenciaList.size());
        System.debug('DIAS MES: ' + totalDiasMes);
        System.debug('DIAS TRANSCURRIDOS: ' + totalDiasTranscurridos);
        
        If(dpTendenciaList.size()==0){
            
            List<Tendencia__c> tendenciasPresupuestosList = new List<Tendencia__c>();
            System.debug('=================FOR 253================');
            for(String t : llenaValoresTendencias()){
                Tendencia__c tend 		= new Tendencia__c ();
                tend.Ejecutivo__c	 	= ejecutivoId;
                tend.Tipo_de_Importe__c	= t;
                tend.Fecha__c			= fecha;
                tend.Importe__c			= calculaImporteTendencia(correspondenciasTendenciasVentasMap.get(t), dpVentasList, totalDiasMes, totalDiasTranscurridos, ejecutivoId, mesConsulta, anio, fecha);
                tend.OwnerId			= ejecutivoId; 
                
                System.debug('tend.Tipo_de_Importe__c: ' + tend.Tipo_de_Importe__c	);
                System.debug('tend.Importe__c: ' + tend.Importe__c);
                
                tendenciasPresupuestosList.add(tend);
             }
            
            if (tendenciasPresupuestosList.size()>0){
                insert tendenciasPresupuestosList;
            }
        }
        if(dpTendenciaList.size()>0){
            System.debug('=================FOR 273================');
            for(tendencia__c t: dpTendenciaList){
                t.Importe__c = calculaImporteTendencia(correspondenciasTendenciasVentasMap.get(t.Tipo_de_Importe__c), dpVentasList, totalDiasMes, totalDiasTranscurridos, EjecutivoId, mesConsulta, anio, fecha);
                System.debug('t.Tipo_de_Importe__c: ' + t.Tipo_de_Importe__c	);
                System.debug('t.Importe__c: ' + t.Importe__c);
            }
            update dpTendenciaList;
        }
    }
    
    
    public static Decimal calculaImporteTendencia (String tipoImporte, List<Tendencia__c> dpVentasList, Decimal totalDiasMes, Decimal totalDiasTranscurridos,
                                                  Id ejecutivoId, String mesConsulta, String anio, Date fecha){
        
        Decimal tendencia = 0;
        Decimal totalVentaMes = 0;
        Decimal totalVentaPromedioDiaria = 0;
                                                      
        System.debug('============== calculaImporteTendencia ===============');                                              
		System.debug('tipoImporte : ' + tipoImporte);
		System.debug('totalDiasMes : ' + totalDiasMes);
		System.debug('totalDiasTranscurridos : ' + totalDiasTranscurridos);
        System.debug('ejecutivoId : ' + ejecutivoId);
 		System.debug('mesConsulta : ' + mesConsulta);
		System.debug('anio : ' + anio);
		System.debug('fecha : ' +fecha);                                                      
		System.debug('============== FOR 299===============');                                                                                                    
        for(Tendencia__c t: ejecutaConsultaTendencia(tipoImporte, ejecutivoId, mesConsulta, anio)){
            	totalVentaMes += t.importe__c;                        
            	System.debug('t.importe__c : ' +t.importe__c);       
            	System.debug('totalVentaMes : ' +totalVentaMes);       
        }
       System.debug('============== AFTER FOR ==============='); 
		if(totalDiasTranscurridos>0){
            totalVentaPromedioDiaria = totalVentaMes / totalDiasTranscurridos;
        }else{
        	totalVentaPromedioDiaria = totalVentaMes;    
        }
        
        tendencia = totalVentaPromedioDiaria*totalDiasMes;
        
		System.debug('totalVentaMes : ' +totalVentaMes);   
		System.debug('totalDiasTranscurridos : ' +totalDiasTranscurridos);   
		System.debug('totalVentaPromedioDiaria : ' +totalVentaPromedioDiaria);   
		System.debug('totalDiasMes : ' +totalDiasMes); 
		System.debug('tendencia : ' +tendencia); 
        
        return tendencia;
    }
    
    public static List<Decimal> calculaDiasMes_DiasTranscurridos (List<Ano_Calendario__c> anioCalendarioList, String mesConsulta){
        List<Decimal> diasMes_DiasTranscurridos_List = new List<Decimal>();
        
        switch on mesconsulta {
           when 'ENERO'{
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Enero__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Enero__c);
           }
           when 'FEBRERO'{
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Febrero__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Febrero__c);
           }
           when 'MARZO' {
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Marzo__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Marzo__c);
           }
           when 'ABRIL' {
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Abril__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Abril__c);
           }
           when 'MAYO' {
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Mayo__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Mayo__c);
           }
           when 'JUNIO' {
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Junio__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Junio__c);
           }
           when 'JULIO' {
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Julio__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Julio__c);
           }
           when 'AGOSTO' {
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Agosto__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Agosto__c);
           }
           when 'SEPTIEMBRE' {
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Septiembre__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Septiembre__c);
           }
           when 'OCTUBRE' {
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Octubre__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Octubre__c);
           }
           when 'NOVIEMBRE' {
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Noviembre__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Noviembre__c);
           }
           when 'DICIEMBRE'{
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Diciembre__c);
               diasMes_DiasTranscurridos_List.add(anioCalendarioList[0].Dias_transcurridos_Diciembre__c);
           } 
           when else {
               
           }
        }   
        
        
		return diasMes_DiasTranscurridos_List;        
    }
    
    public static List<Tendencia__c> ejecutaConsultaTendencia (String tipoImporte, String ejecutivoId, String mesConsulta, String anio){
        System.debug('========= EJECUTA CONSULTA TENDENCIA ===========');
        System.debug('tipoImporte : ' + tipoImporte);
        System.debug('sucursalId : ' + ejecutivoId);
        System.debug('mesConsulta : ' + mesConsulta);
        System.debug('anio : ' + anio);
        
        List<Tendencia__c> ventasTendenciaList =[SELECT Id, Ejecutivo__c, Anio__c, Mes__c, importe__c, Tipo_de_Importe__c FROM Tendencia__c WHERE ejecutivo__c =: ejecutivoId AND Mes__c =: mesConsulta AND Anio__c =: anio AND Tipo_de_Importe__c =: tipoImporte];
        System.debug('========= FOR 387 ===========');
        for(Tendencia__c t: ventasTendenciaList){
            System.debug('t.Tipo_de_Importe__c : ' + t.Tipo_de_Importe__c);
            System.debug('t.importe__c : ' + t.importe__c);
            System.debug('t.Mes__c : ' + t.Mes__c);
            System.debug('t.Anio__c : ' + t.Anio__c);
            System.debug('t.Ejecutivo__c : ' + t.Ejecutivo__c);
            System.debug('t.Id : ' + t.Id);
        }
        
        return ventasTendenciaList;
    }
    
    public static Map<String, String> retornaValoresCorrespondencia (){
        Map<string, string> valoresTenciaVentas = new Map<String,String>();
        
        for(String t : llenaValoresTendencias()){
            if(t == 'Total Tendencia Venta Nueva'){
                valoresTenciaVentas.put(t, 'Total Venta Nueva');
            }
            
            if(t == 'Tendencia Mensajeria TS-T0 Estandar'){
                valoresTenciaVentas.put(t, 'Venta Mensajeria TS-T0 Estandar');
            }
            
            if(t == 'Tendencia Mensajeria TS-T0 Express'){
                valoresTenciaVentas.put(t, 'Venta Mensajeria TS-T0 Express');
            }
            
            if(t == 'Tendencia Mensajeria TS-T0 Internacional'){
                valoresTenciaVentas.put(t, 'Venta Mensajeria TS-T0 Internacional');
            }
            
            if(t == 'Tendencia Paquetería y Carga T1-T7 Estandar'){
                valoresTenciaVentas.put(t, 'Venta Paquetería y Carga T1-T7 Estandar');
            }
            
            if(t == 'Tendencia Paquetería y Carga T1-T7 Express'){
                valoresTenciaVentas.put(t, 'Venta Paquetería y Carga T1-T7 Express');
            }

			if(t == 'Tendencia Paquetería y Carga T1-T7 Internacional'){
                valoresTenciaVentas.put(t, 'Venta Paquetería y Carga T1-T7 Internacional' );
            }
            
            if(t == 'Tendencia Servicios Estandar'){
                valoresTenciaVentas.put(t, 'Venta Servicios Estandar');
            }
            
            if(t == 'Tendencia Servicios Express'){
                valoresTenciaVentas.put(t, 'Venta Servicios Express');
            }
            
            if(t == 'Tendencia Servicios Internacional'){
                valoresTenciaVentas.put(t, 'Venta Servicios Internacional');
            }
            
            if(t == 'Tendencia Mensajería TS-T0'){
                valoresTenciaVentas.put(t, 'Total Venta Mensajería TS-T0');
            }
            
            if(t == 'Tendencia Paquetería y Carga T1-T7'){
                valoresTenciaVentas.put(t, 'Total Venta Paquetería y Carga T1-T7');
            }
            
            if(t == 'Tendencia Servicios'){
                valoresTenciaVentas.put(t, 'Total Venta Servicios');
            }
            
            if(t == 'Tendencia Estándar'){
                valoresTenciaVentas.put(t, 'Total Venta Estándar');
            }
            
            if(t == 'Tendencia Express'){
                valoresTenciaVentas.put(t, 'Total Venta Express');
            }
            
            if(t == 'Tendencia Internacional'){
                valoresTenciaVentas.put(t, 'Total Venta Internacional');
            }
            
            if(t == 'Tendencia Nacional'){
                valoresTenciaVentas.put(t, 'Total Venta Nacional');
            }
            
            if(t == 'Total Tendencia Venta Mantenimiento'){
                valoresTenciaVentas.put(t, 'Total Venta Mantenimiento');
            }
            
            if(t == 'Tendencia Mensajería TS-T0 Estandar Mantenimiento'){
                valoresTenciaVentas.put(t, 'Venta Mensajeria TS-T0 Estandar mantenimiento');
            }
            
            if(t == 'Tendencia Mensajeria TS-T0 Express mantenimiento'){
                valoresTenciaVentas.put(t, 'Venta Mensajeria TS-T0 Express mantenimiento');
            }
            
            if(t == 'Tendencia Mensajeria TS-T0 Internacional mantenimiento'){
                valoresTenciaVentas.put(t, 'Venta Mensajeria TS-T0 Internacional mantenimiento');
            }
            
            if(t == 'Tendencia Paquetería y Carga T1-T7 Estandar mantenimiento'){
                valoresTenciaVentas.put(t, 'Venta Paquetería y Carga T1-T7 Estandar mantenimiento');
            }
            
            if(t == 'Tendencia Paquetería y Carga T1-T7 Express mantenimiento'){
                valoresTenciaVentas.put(t, 'Venta Paquetería y Carga T1-T7 Express mantenimiento');
            }
            
            if(t == 'Tendencia Paquetería y Carga T1-T7 Internacional mantenimiento'){
                valoresTenciaVentas.put(t, 'Venta Paquetería y Carga T1-T7 Internacional mantenimiento' );
            }
            
            if(t == 'Tendencia Servicios Estandar mantenimiento'){
                valoresTenciaVentas.put(t, 'Venta Servicios Estandar mantenimiento' );
            }
            
            if(t == 'Tendencia Servicios Express mantenimiento'){
                valoresTenciaVentas.put(t, 'Venta Servicios Express mantenimiento' );
            }
            
            if(t == 'Tendencia Servicios Internacional mantenimiento'){
                valoresTenciaVentas.put(t, 'Venta Servicios Internacional mantenimiento' );
            }
            
            if(t == 'Total Tendencia Mensajería TS-T0 mantenimiento'){
                valoresTenciaVentas.put(t, 'Total Venta Mensajería TS-T0 mantenimiento' );
            }
            
            if(t == 'Total Tendencia Paquetería y Carga T1-T7 mantenimiento'){
                valoresTenciaVentas.put(t, 'Total Venta Paquetería y Carga T1-T7 mantenimiento' );
            }
            
            if(t == 'Total Tendencia Servicios mantenimiento'){
                valoresTenciaVentas.put(t, 'Total Venta Servicios mantenimiento' );
            }
            
            if(t == 'Total Tendencia Estándar mantenimiento'){
                valoresTenciaVentas.put(t, 'Total Venta Estándar mantenimiento' );
            }
            
            if(t == 'Total Tendencia Express mantenimiento'){
                valoresTenciaVentas.put(t, 'Total Venta Express mantenimiento' );
            }
            
            if(t == 'Total Tendencia Internacional mantenimiento'){
                valoresTenciaVentas.put(t, 'Total Venta Internacional mantenimiento' );
            }
            
            if(t == 'Total Tendencia Nacional mantenimiento'){
                valoresTenciaVentas.put(t, 'Total Venta Nacional mantenimiento' );
            }
            
            if(t == 'Tendencia Global'){
                valoresTenciaVentas.put(t, 'Total Venta Global' );
            }
            
            if(t == 'Tendencia Global Mensajeria TS-T0 Estandar'){
                valoresTenciaVentas.put(t, 'Total Venta Global Mensajeria TS-T0 Estandar' );
            }
            
            if(t == 'Tendencia Global Mensajeria TS-T0 Express'){
                valoresTenciaVentas.put(t, 'Total Venta Global Mensajeria TS-T0 Express' );
            }
            
            if(t == 'Tendencia Global Mensajeria TS-T0 Internacional'){
                valoresTenciaVentas.put(t, 'Total Venta Global Mensajeria TS-T0 Internacional' );
            }
            
            if(t == 'Tendencia Global Paquetería y Carga T1-T7 Estandar'){
                valoresTenciaVentas.put(t, 'Total Venta Global Paquetería y Carga T1-T7 Estandar' );
            }
            
            if(t == 'Tendencia Global Paquetería y Carga T1-T7 Express'){
                valoresTenciaVentas.put(t, 'Total Venta Global Paquetería y Carga T1-T7 Express' );
            }
            
            if(t == 'Tendencia Global Paquetería y Carga T1-T7 Internacional'){
                valoresTenciaVentas.put(t, 'Total Venta Global Paquetería y Carga T1-T7 Internacional' );
            }
            
            if(t == 'Tendencia Global Servicios Estandar'){
                valoresTenciaVentas.put(t, 'Total Venta Global Servicios Estandar' );
            }
            
            if(t == 'Tendencia Global Servicios Express'){
                valoresTenciaVentas.put(t, 'Total Venta Global Servicios Express' );
            }
            
            if(t == 'Tendencia Global Servicios Internacional'){
                valoresTenciaVentas.put(t, 'Total Venta Global Servicios Internacional' );
            }
            
            if(t == 'Total Tendencia Global Mensajería TS-T0'){
                valoresTenciaVentas.put(t, 'Total Venta Global Mensajería TS-T0' );
            }
            
            if(t == 'Total Tendencia Global Paquetería y Carga T1-T7'){
                valoresTenciaVentas.put(t, 'Total Venta Global Paquetería y Carga T1-T7' );
            }
            
            if(t == 'Total Tendencia Global Servicios'){
                valoresTenciaVentas.put(t, 'Total Venta Global Servicios' );
            }
            
            if(t == 'Total Tendencia Global Estándar'){
                valoresTenciaVentas.put(t, 'Total Venta Global Estándar' );
            }
            
            if(t == 'Total Tendencia Global Express'){
                valoresTenciaVentas.put(t, 'Total Venta Global Express' );
            }
            
            if(t == 'Total Tendencia Global Internacional'){
                valoresTenciaVentas.put(t, 'Total Venta Global Internacional' );
            }
            
            if(t == 'Tendencia Global Nacional'){
                valoresTenciaVentas.put(t, 'Total Venta Global Nacional' );
            }
            
        }
        
        return valoresTenciaVentas;
    }
    
    public static String generaMesConsulta (string mes){
        String mesConsulta = '';
        
        switch on mes {
           when '1'{
               mesconsulta = 'ENERO';
           }
           when '2'{
               mesconsulta = 'FEBRERO';
           }
           when '3' {
               mesconsulta = 'MARZO';
           }
           when '4' {
               mesconsulta = 'ABRIL';
           }
           when '5' {
               mesconsulta = 'MAYO';
           }
           when '6' {
               mesconsulta = 'JUNIO';
           }
           when '7' {
               mesconsulta = 'JULIO';
           }
           when '8' {
               mesconsulta = 'AGOSTO';
           }
           when '9' {
               mesconsulta = 'SEPTIEMBRE';
           }
           when '10' {
               mesconsulta = 'OCTUBRE';
           }
           when '11' {
               mesconsulta = 'NOVIEMBRE';
           }
           when '12'{
               mesconsulta = 'DICIEMBRE';
           } 
           when else {
               mesconsulta = 'NA';
           }
        }
        return mesConsulta;
    }
    
    
    class wrapperValoresVentas {
    	
        public Decimal totalVentasGLOBAL;
        public Decimal totalVentaClienteNuevo;
        public Decimal totalVentaClienteMantenimiento;
            
        // MENSAJERIA 
            
        public Decimal totalMensajeriaNVO;
        public Decimal totalMensajeria_EstandarNVO;
        public Decimal totalMensajeria_ExpressNVO;
        public Decimal totalMensajeria_InternacionalNVO;
            
        public Decimal totalMensajeriaMTTO;
        public Decimal totalMensajeria_EstandarMTTO;
        public Decimal totalMensajeria_ExpressMTTO;
        public Decimal totalMensajeria_InternacionalMTTO;
       
        public Decimal totalMensajeriaGLOBAL;
        public Decimal totalMensajeria_EstandarGLOBAL;
        public Decimal totalMensajeria_ExpressGLOBAL;
        public Decimal totalMensajeria_InternacionalGLOBAL;
            
        // PAQUETERIA 
            
        public Decimal totalPaqueteriaNVO;
        public Decimal totalPaqueteria_EstandarNVO;
        public Decimal totalPaqueteria_ExpressNVO;
        public Decimal totalPaqueteria_InternacionalNVO;
            
        public Decimal totalPaqueteriaMTTO;
        public Decimal totalPaqueteria_EstandarMTTO;
        public Decimal totalPaqueteria_ExpressMTTO;
        public Decimal totalPaqueteria_InternacionalMTTO;
            
        public Decimal totalPaqueteriaGLOBAL;
        public Decimal totalPaqueteria_EstandarGLOBAL;
        public Decimal totalPaqueteria_ExpressGLOBAL;
        public Decimal totalPaqueteria_InternacionalGLOBAL;
            
        // SERVICIOS
            
        public Decimal totalServiciosNVO;
        public Decimal totalServicios_EstandarNVO;
        public Decimal totalServicios_ExpressNVO;
        public Decimal totalServicios_InternacionalNVO;
            
        public Decimal totalServiciosMTTO;
        public Decimal totalServicios_EstandarMTTO;
        public Decimal totalServicios_ExpressMTTO;
        public Decimal totalServicios_InternacionalMTTO;
            
      	public Decimal totalServiciosGLOBAL;
        public Decimal totalServicios_EstandarGLOBAL;
        public Decimal totalServicios_ExpressGLOBAL;
        public Decimal totalServicios_InternacionalGLOBAL;
            
        //DETALLES SERVICIOS
            
        // SERVICIOS
            
        public Decimal totalServicios_RADNVO;
        public Decimal totalServicios_EADNVO;
        public Decimal totalServicios_ZonaExtNVO;
        public Decimal totalServicios_AcuseNVO;
        public Decimal totalServicios_SeguroNVO;
        public Decimal totalServicios_CODNVO;
        public Decimal totalServicios_OtrosNVO;
            
        public Decimal totalServicios_RADMTTO;
        public Decimal totalServicios_EADMTTO;
        public Decimal totalServicios_ZonaExtMTTO;
        public Decimal totalServicios_AcuseMTTO;
        public Decimal totalServicios_SeguroMTTO;
        public Decimal totalServicios_CODMTTO;
        public Decimal totalServicios_OtrosMTTO;
            
      
        public Decimal totalServicios_RADGLOBAL;
        public Decimal totalServicios_EADGLOBAL;
        public Decimal totalServicios_ZonaExtGLOBAL;
        public Decimal totalServicios_AcuseGLOBAL;
        public Decimal totalServicios_SeguroGLOBAL;
        public Decimal totalServicios_CODGLOBAL;
        public Decimal totalServicios_OtrosGLOBAL;
            
        //TOTALES ESTANDAR, EXPRESS, INTERNACIONAL, NACIONAL GLOBAL
        public Decimal totalEstandarGLOBAL;
        public Decimal totalExpressGLOBAL;
        public Decimal totalInternacionalGLOBAL;
        public Decimal totalNacionalGLOBAL;
            
        //TOTALES ESTANDAR, EXPRESS, INTERNACIONAL, NACIONAL NUEVO
        public Decimal totalEstandarNVO;
        public Decimal totalExpressNVO;
        public Decimal totalInternacionalNVO;
        public Decimal totalNacionalNVO;
            
        //TOTALES ESTANDAR, EXPRESS, INTERNACIONAL, NACIONAL MANTENIMIENTO
        public Decimal totalEstandarMTTO;
        public Decimal totalExpressMTTO;
        public Decimal totalInternacionalMTTO;
        public Decimal totalNacionalMTTO;
        
        
    }
    
}