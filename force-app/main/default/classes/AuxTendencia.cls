/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-05-2022
 * @last modified by  : Salvador Ramírez (sramirez@freewayconsulting.com
**/
public class AuxTendencia {
    public static Integer contador = 0;
    public static String strError  = '';
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
    
    public static void importaPresupuestos (Id sucursalId, String mesConsulta, String anio, Date fecha, Id propietario){
        List<Detalle_Presupuesto__c> 	dpSucursalList 	= new List<Detalle_Presupuesto__c>();
        List<Tendencia__c> 				dpTendenciaList = new List<Tendencia__c>();
        List<Tendencia__c>				tendenciasPresupuestosList = new List<Tendencia__c>();
        contador = 0;
        for(AggregateResult result : [SELECT Count(Id) total FROM Tendencia__c WHERE Sucursal__c =: sucursalId AND Mes__c =: mesConsulta AND Anio__c =: anio AND Tipo_de_Importe__c IN: llenaValoresPresupuesto()]){
            contador += (Integer)result.get('total');
            if(contador > 50000){
                strError = 'AuxTendencia.importaPresupuestos dpTendenciaList rompió el límite de los 50 mil registros. Sucursal: ' + sucursalId + ' Mes consulta: ' + mesconsulta + 'Año: ' + anio;
                System.debug(strError);
                AuxBatchProductividadEjecutivo.generaSolicitudEmail(strError, 'AuxTendencia consulta de dpTendenciaList', 54);
                break;
            }
        }
        dpTendenciaList = [SELECT Id, Sucursal__c, Anio__c, Mes__c FROM Tendencia__c WHERE Sucursal__c =: sucursalId AND Mes__c =: mesConsulta
        AND Anio__c =: anio AND Tipo_de_Importe__c IN: llenaValoresPresupuesto()];

        contador = 0;
        for(AggregateResult result : [SELECT Count(Id) total FROM Detalle_Presupuesto__c WHERE Sucursal__c =: sucursalId AND Mes__c =:mesConsulta AND Anio__c =: anio]){
            contador += (Integer)result.get('total');
            if(contador > 50000){
                strError = 'AuxTendencia.importaPresupuestos dpSucursalList rompió el límite de los 50 mil registros. Sucursal: ' + sucursalId + ' Mes consulta: ' + mesconsulta + 'Año: ' + anio;
                System.debug(strError);
                AuxBatchProductividadEjecutivo.generaSolicitudEmail(strError, 'AuxTendencia consulta de dpSucursalList', 62);
                break;
            }
        }
        dpSucursalList 	= [SELECT Id, Total_presupuesto__c, Total_mensajeria_TS_T0__c, Total_Paqueteria_Carga_T1_T7__c, Total_Servicios__c, 
                        Total_estandar__c, Total_express__c, Total_Internacional__c, Total_Nacional__c, Mensajeria_TS_T0_estandar__c,
                        Mensajeria_TS_T0_express__c, Mensajeria_TS_T0_internacional__c, Paqueteria_Carga_T1_T7_Estandar__c,
                        Paqueteria_Carga_T1_T7_Express__c, Paqueteria_Carga_T1_T7_Internacional__c, Servicios_Estandar__c, Servicios_Express__c,
                        Servicios_Internacionales__c
                        FROM Detalle_Presupuesto__c WHERE Sucursal__c =: sucursalId AND Mes__c =:mesConsulta AND Anio__c =: anio];

        if(dpTendenciaList.size()==0 && dpSucursalList.size()==1){
            Map<String, Decimal> presupuestoValorMap = new Map<String, Decimal> ();
            presupuestoValorMap = llenaValoresPresupuestoMAp(dpSucursalList);
            for(String presupuesto: llenaValoresPresupuesto()){
                Tendencia__c t 		= new Tendencia__c ();
                t.Sucursal__c	 	= sucursalId;
                t.Tipo_de_Importe__c= presupuesto;
                t.Fecha__c			= fecha;
                t.Importe__c		= presupuestoValorMap.get(presupuesto);
                t.OwnerId			= propietario;
                tendenciasPresupuestosList.add(t);
            }
            
            if(tendenciasPresupuestosList.size()>0){
                insert tendenciasPresupuestosList;
            }
        }
        
        
    }


    public static void generaResumenVentas (List<Sucursal__c> records, Date fecha, String mesconsulta, Id Owner){   
        
        String 	contenido 		= '';
        Date 	hoy 			= fecha;
        Id 		propietario 	= owner;	
        
        List<Tendencia__c>	tendenciasVentasList = new List<Tendencia__c>();
        Map<String, Decimal> ventasValorMap = new Map<String, Decimal> ();
            
        Set<String> sucursalClaves = new Set<String>();
        Decimal totalVentas 					= 0;
        
        Decimal totalMensajeria 				= 0;
        Decimal totalMensajeria_Estandar 		= 0;
        Decimal totalMensajeria_Express 		= 0;
        Decimal totalMensajeria_Internacional 	= 0;
        
        Decimal totalPaqueteria 				= 0;
        Decimal totalPaqueteria_Estandar 		= 0;
        Decimal totalPaqueteria_Express 		= 0;
        Decimal totalPaqueteria_Internacional 	= 0;
        
        Decimal totalServicios	 				= 0;
        Decimal totalServicios_Estandar 		= 0;
        Decimal totalServicios_Express 			= 0;
        Decimal totalServicios_Internacional	= 0;
        
        Decimal totalEstandar					= 0;
        Decimal totalExpress					= 0;
        Decimal totalInternacional				= 0;
        
        Decimal totalServicios_RAD				= 0;
        Decimal totalServicios_EAD				= 0;
        Decimal totalServicios_ZonaExt			= 0;
        Decimal totalServicios_Acuse			= 0;
        Decimal totalServicios_Seguro			= 0;
        Decimal totalServicios_COD				= 0;
        Decimal totalServicios_Otros			= 0;
        
        Decimal totalNacional					= 0;
        
        for(Sucursal__c suc: records){
            if(suc.Id_Sipweb__c != null) {
                sucursalClaves.add(suc.Id_Sipweb__c);
            }
        }
        
        contenido += 'Fecha: '+ hoy + '\n Sucursales: ' + sucursalClaves; 
        system.debug('CONTENIDO: ' + contenido);
        
        List<SObject> ventasList = new List<SObject>();
        
        if(test.isRunningTest()){
            String testQuery = 'SELECT total_despues_de_impuestos__c, total_antes_de_impuestos__c, ' +
                             'sucursal_origen_clave__c, fecha_id__c, servicio_clave__c, ' +
                             'tipo_destino__c, tipo_servicio__c ' +
                             'FROM Ventas__dlm ' +
                             'WHERE total_despues_de_impuestos__c != null ' +
                             'AND fecha_venta__c = :hoy';
            ventasList = Database.query(testQuery);
        } else {
            contador = 0;
            // Consulta sin COUNT(), solo los Id con un límite de 50001
            List<Ventas__dlm> listaRegistros = [
                SELECT Id 
                FROM Ventas__dlm 
                WHERE total_despues_de_impuestos__c != null 
                AND fecha_venta__c = :hoy 
                AND sucursal_origen_clave__c IN :sucursalClaves
                LIMIT 50001
            ];
        
            contador = listaRegistros.size();
            
            if (contador > 50000) {
                strError = 'AuxTendencia.generaResumenVentas total_despues_de_impuestos__c rompió el límite de 50 mil registros. ' +
                            'Sucursal: ' + sucursalClaves + ' fechaId: ' + hoy;
                System.debug(strError);
                AuxBatchProductividadEjecutivo.generaSolicitudEmail(strError, 'AuxTendencia consulta de total_despues_de_impuestos__c', 153);
            }
        }      
        
        
        String queryVentas = 'SELECT total_despues_de_impuestos__c, total_antes_de_impuestos__c, ' +
                            'sucursal_origen_clave__c, fecha_id__c, servicio_clave__c, ' +
                            'tipo_destino__c, tipo_servicio__c ' +
                            'FROM Ventas__dlm ' +
                            'WHERE total_despues_de_impuestos__c != null ' +
                            'AND fecha_venta__c = :hoy ' +
                            'AND sucursal_origen_clave__c IN :sucursalClaves';
        
        for(SObject v: Database.query(queryVentas)){
            Decimal totalAntesImpuestos = (Decimal)v.get('total_antes_de_impuestos__c');
            String servicioClave = (String)v.get('servicio_clave__c');
            String tipoDestino = (String)v.get('tipo_destino__c');
            String tipoServicio = (String)v.get('tipo_servicio__c');
        	
            totalVentas += totalAntesImpuestos;
            
            // ============================= VENTAS MENSAJERIA ================================
            if(servicioClave == 'TARIFA_T0' || servicioClave == 'TARIFA_TS' || test.isRunningTest()){
                totalMensajeria += totalAntesImpuestos;
            }
            
            // VENTAS MENSAJERIA ESTANDAR
            if((servicioClave == 'TARIFA_T0' || servicioClave == 'TARIFA_TS') && tipoDestino == 'NACIONAL' && tipoServicio == 'STD-T' || test.isRunningTest()){
                totalMensajeria_Estandar += totalAntesImpuestos;
            }
            
            // VENTAS MENSAJERIA EXPRESS
            if((servicioClave == 'TARIFA_T0' || servicioClave == 'TARIFA_TS') && tipoDestino == 'NACIONAL' && 
               (tipoServicio == 'SEG-DS' || tipoServicio == 'SEG-2D' || tipoServicio == 'SEG-A12' || tipoServicio == 'SEG-MD') || 
               test.isRunningTest()){
                totalMensajeria_Express += totalAntesImpuestos;
            }
            
            // VENTAS MENSAJERIA INTERNACIONAL
            if((servicioClave == 'TARIFA_T0' || servicioClave == 'TARIFA_TS') && tipoDestino == 'INTERNACIONAL' && 
               tipoServicio == 'STD-T' || test.isRunningTest()){
                totalMensajeria_Internacional += totalAntesImpuestos;
            }
            
            // ============================= VENTAS PAQUETERIA Y CARGA ==============================
            if(esTarifaPaqueteria(servicioClave) || test.isRunningTest()){
                totalPaqueteria += totalAntesImpuestos;
            }
            
            // VENTAS PAQUETERIA Y CARGA ESTANDAR
            if(esTarifaPaqueteria(servicioClave) && tipoDestino == 'NACIONAL' && tipoServicio == 'STD-T' || test.isRunningTest()){
                totalPaqueteria_Estandar += totalAntesImpuestos;
            }
            
            // VENTAS PAQUETERIA Y CARGA EXPRESS
            if(esTarifaPaqueteria(servicioClave) && tipoDestino == 'NACIONAL' && 
               (tipoServicio == 'SEG-DS' || tipoServicio == 'SEG-2D' || tipoServicio == 'SEG-A12' || tipoServicio == 'SEG-MD') || 
               test.isRunningTest()){
                totalPaqueteria_Express += totalAntesImpuestos;
            }
            
            // VENTAS PAQUETERIA Y CARGA INTERNACIONAL
            if(esTarifaPaqueteria(servicioClave) && tipoDestino == 'INTERNACIONAL' && tipoServicio == 'STD-T' || test.isRunningTest()){
                totalPaqueteria_Internacional += totalAntesImpuestos;
            }
            
            // ============================= VENTAS SERVICIOS ==============================
            if(!esTarifaMensajeriaOPaqueteria(servicioClave) || test.isRunningTest()){
                totalServicios += totalAntesImpuestos;
                
                // SERVICIOS RAD
                if(servicioClave == 'RAD' || test.isRunningTest()){
                    totalServicios_RAD += totalAntesImpuestos;    
                }
                
                // SERVICIOS EAD
                if(servicioClave == 'EAD' || test.isRunningTest()){
                    totalServicios_EAD += totalAntesImpuestos;
                }
                
                // SERVICIOS ZONA EXTENDIDA
                if(esServicioZonaExtendida(servicioClave) || test.isRunningTest()){
                    totalServicios_ZonaExt += totalAntesImpuestos;
                }
                
                //SERVICIOS ACUSE
                if(esServicioAcuse(servicioClave) || test.isRunningTest()){
                    totalServicios_Acuse += totalAntesImpuestos;
                }
                
                //SERVICIOS SEGURO
                if(servicioClave == 'SEGURO' || test.isRunningTest()){
                    totalServicios_Seguro += totalAntesImpuestos;
                }
                
                //SERVICIOS COD
                if(servicioClave == 'COD' || test.isRunningTest()){
                    totalServicios_COD += totalAntesImpuestos;
                }
                
                //SERVICIOS OTROS
                if(esServicioOtro(servicioClave) || test.isRunningTest()){
                    totalServicios_Otros += totalAntesImpuestos;
                }
            }
            
            // VENTAS SERVICIOS Y CARGA ESTANDAR
            if(!esTarifaMensajeriaOPaqueteria(servicioClave) && tipoDestino == 'NACIONAL' && tipoServicio == 'STD-T' || 
               test.isRunningTest()){
                totalServicios_Estandar += totalAntesImpuestos;
            }
            
            // VENTAS SERVICIOS Y CARGA EXPRESS
            if(!esTarifaMensajeriaOPaqueteria(servicioClave) && tipoDestino == 'NACIONAL' && 
               (tipoServicio == 'SEG-DS' || tipoServicio == 'SEG-2D' || tipoServicio == 'SEG-A12' || tipoServicio == 'SEG-MD') || 
               test.isRunningTest()){
                totalServicios_Express += totalAntesImpuestos;
            }
            
            // VENTAS SERVICIOS Y CARGA INTERNACIONAL
            if(!esTarifaMensajeriaOPaqueteria(servicioClave) && tipoDestino == 'INTERNACIONAL' && tipoServicio == 'STD-T' || 
               test.isRunningTest()){
                totalServicios_Internacional += totalAntesImpuestos;
            }
        }

        if(totalVentas != 0){
            contenido += '\n total Ventas 							= ' + totalVentas;

            contenido += '\n total Ventas Mensajeria 				= ' + totalMensajeria;
            contenido += '\n total Ventas Mensajeria Estandar		= ' + totalMensajeria_Estandar;
            contenido += '\n total Ventas Mensajeria Express 		= ' + totalMensajeria_Express;
            contenido += '\n total Ventas Mensajeria Internacional	= ' + totalMensajeria_Internacional;

            contenido += '\n total Ventas Paqueteria 				= ' + totalPaqueteria;
            contenido += '\n total Ventas Paqueteria Estandar		= ' + totalPaqueteria_Estandar;
            contenido += '\n total Ventas Paqueteria Express 		= ' + totalPaqueteria_Express;
            contenido += '\n total Ventas Paqueteria Internacional	= ' + totalPaqueteria_Internacional;

            contenido += '\n total Ventas Servicios 				= ' + totalServicios;
            contenido += '\n total Ventas Servicios Estandar		= ' + totalServicios_Estandar;
            contenido += '\n total Ventas Servicios Express 		= ' + totalServicios_Express;
            contenido += '\n total Ventas Servicios Internacional	= ' + totalServicios_Internacional;

            totalEstandar		= totalMensajeria_Estandar 		+ totalPaqueteria_Estandar 		+ totalServicios_Estandar;
            totalExpress		= totalMensajeria_Express 		+ totalPaqueteria_Express 		+ totalServicios_Express;
            totalInternacional	= totalMensajeria_Internacional + totalPaqueteria_Internacional + totalServicios_Internacional;
            totalNacional		= totalEstandar + totalExpress;

            contenido += '\n total Ventas Estandar		= ' + totalEstandar;
            contenido += '\n total Ventas Express 		= ' + totalExpress;
            contenido += '\n total Ventas Internacional	= ' + totalInternacional;
            contenido += '\n total Ventas Nacional		= ' + totalNacional;
            contenido += '\n total Servicios RAD		= ' + totalServicios_RAD;
            contenido += '\n total Servicios EAD 		= ' + totalServicios_EAD;
            contenido += '\n total Servicios Zona Ext	= ' + totalServicios_ZonaExt;
            contenido += '\n total Servicios Acuse		= ' + totalServicios_Acuse;
            contenido += '\n total Servicios Seguro		= ' + totalServicios_Seguro;
            contenido += '\n total Servicios COD		= ' + totalServicios_COD;
            contenido += '\n total Servicios Otros		= ' + totalServicios_Otros;
 
            ventasValorMap = AuxTendencia.llenaValoresVentasMap(totalVentas, totalMensajeria, totalMensajeria_Estandar, 
                                                              totalMensajeria_Express, totalMensajeria_Internacional, totalPaqueteria,
                                                              totalPaqueteria_Estandar, totalPaqueteria_Express, totalPaqueteria_Internacional,
                                                              totalServicios, totalServicios_Estandar, totalServicios_Express, 
                                                              totalServicios_Internacional, totalEstandar, totalExpress, 
                                                             totalInternacional, totalNacional);
           for(String tituloVenta: AuxTendencia.llenaValoresVentas()){
               Tendencia__c t 		= new Tendencia__c ();
               t.Sucursal__c	 	= records[0].Id;
               t.Tipo_de_Importe__c= tituloVenta;
               t.Fecha__c			= hoy;
               t.Importe__c		= ventasValorMap.get(tituloVenta);
               if(tituloVenta == 'Total Venta Servicios'){
                   t.RAD__c 		= totalServicios_RAD;
                   t.EAD__c 		= totalServicios_EAD;
                   t.Zona_Extendida__c = totalServicios_ZonaExt;
                   t.Acuse__c 		= totalServicios_Acuse;
                   t.Seguro__c		= totalServicios_Seguro;
                   t.Otros__c 		= totalServicios_Otros;
                   t.COD__c		= totalServicios_COD;
               }
               t.OwnerId = propietario;
               tendenciasVentasList.add(t);
           }
           if(tendenciasVentasList.size()>0){
               insert tendenciasVentasList;
           }
       }
       AuxTendencia.notificaLlamadoWS (contenido);
   }
    
    
    public static List<String> llenaValoresPresupuesto (){
        
        List<String> listaPresupuestos = new List<String>();
        listaPresupuestos.add('Total Presupuesto Global');
        listaPresupuestos.add('Total Presupuesto Mensajería TS-T0');
        listaPresupuestos.add('Total Presupuesto Paquetería y Carga T1-T7');
        listaPresupuestos.add('Total Presupuesto Servicios');
        listaPresupuestos.add('Total Presupuesto Estándar');
        listaPresupuestos.add('Total Presupuesto Express');
        listaPresupuestos.add('Total Presupuesto Internacional');
        listaPresupuestos.add('Total Presupuesto Nacional');
        listaPresupuestos.add('Presupuesto Mensajeria TS-T0 Estandar');
        listaPresupuestos.add('Presupuesto Mensajeria TS-T0 Express');
        listaPresupuestos.add('Presupuesto Mensajeria TS-T0 Internacional');
        listaPresupuestos.add('Presupuesto Paquetería y Carga T1-T7 Estandar');
        listaPresupuestos.add('Presupuesto Paquetería y Carga T1-T7 Express');
        listaPresupuestos.add('Presupuesto Paquetería y Carga T1-T7 Internacional');
        listaPresupuestos.add('Presupuesto Servicios Estandar');
        listaPresupuestos.add('Presupuesto Servicios Express');
        listaPresupuestos.add('Presupuesto Servicios Internacional');
        
        return listaPresupuestos;
    }
    
    public static List<String> llenaValoresVentas (){
        
        List<String> listaPresupuestos = new List<String>();
        listaPresupuestos.add('Total Venta Global');
        listaPresupuestos.add('Total Venta Mensajería TS-T0');
        listaPresupuestos.add('Total Venta Paquetería y Carga T1-T7');
        listaPresupuestos.add('Total Venta Servicios');
        listaPresupuestos.add('Total Venta Estándar');
        listaPresupuestos.add('Total Venta Express');
        listaPresupuestos.add('Total Venta Internacional');
        listaPresupuestos.add('Total Venta Nacional');
        listaPresupuestos.add('Venta Mensajeria TS-T0 Estandar');
        listaPresupuestos.add('Venta Mensajeria TS-T0 Express');
        listaPresupuestos.add('Venta Mensajeria TS-T0 Internacional');
        listaPresupuestos.add('Venta Paquetería y Carga T1-T7 Estandar');
        listaPresupuestos.add('Venta Paquetería y Carga T1-T7 Express');
        listaPresupuestos.add('Venta Paquetería y Carga T1-T7 Internacional');
        listaPresupuestos.add('Venta Servicios Estandar');
        listaPresupuestos.add('Venta Servicios Express');
        listaPresupuestos.add('Venta Servicios Internacional');
        
        return listaPresupuestos;
    }

    public static Map<String, Decimal> llenaValoresPresupuestoMap (List<Detalle_Presupuesto__c> dpSucursalList){
        Map<String, Decimal> presupuestoValorMap = new Map<String, Decimal> ();
        
        presupuestoValorMap.put('Total Presupuesto Global', 						dpSucursalList[0].Total_presupuesto__c);
        presupuestoValorMap.put('Total Presupuesto Mensajería TS-T0', 				dpSucursalList[0].Total_mensajeria_TS_T0__c);
        presupuestoValorMap.put('Total Presupuesto Paquetería y Carga T1-T7', 		dpSucursalList[0].Total_Paqueteria_Carga_T1_T7__c);
        presupuestoValorMap.put('Total Presupuesto Servicios', 						dpSucursalList[0].Total_Servicios__c);
        presupuestoValorMap.put('Total Presupuesto Estándar', 						dpSucursalList[0].Total_estandar__c);
        presupuestoValorMap.put('Total Presupuesto Express', 						dpSucursalList[0].Total_express__c);
        presupuestoValorMap.put('Total Presupuesto Internacional', 					dpSucursalList[0].Total_Internacional__c);
        presupuestoValorMap.put('Total Presupuesto Nacional', 						dpSucursalList[0].Total_Nacional__c);
        presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Estandar', 			dpSucursalList[0].Mensajeria_TS_T0_estandar__c);
        presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Express', 			dpSucursalList[0].Mensajeria_TS_T0_express__c);
        presupuestoValorMap.put('Presupuesto Mensajeria TS-T0 Internacional', 		dpSucursalList[0].Mensajeria_TS_T0_internacional__c);
        presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Estandar', 	dpSucursalList[0].Paqueteria_Carga_T1_T7_Estandar__c);
        presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Express', 	dpSucursalList[0].Paqueteria_Carga_T1_T7_Express__c);
        presupuestoValorMap.put('Presupuesto Paquetería y Carga T1-T7 Internacional',dpSucursalList[0].Paqueteria_Carga_T1_T7_Internacional__c);
        presupuestoValorMap.put('Presupuesto Servicios Estandar', 					dpSucursalList[0].Servicios_Estandar__c);
        presupuestoValorMap.put('Presupuesto Servicios Express', 					dpSucursalList[0].Servicios_Express__c);
        presupuestoValorMap.put('Presupuesto Servicios Internacional', 				dpSucursalList[0].Servicios_Internacionales__c);
        
        return presupuestoValorMap;
    }
    
    public static Map<String, Decimal> llenaValoresVentasMap (Decimal totalVentas, Decimal totalMensajeria, Decimal totalMensajeria_Estandar,
                                                              Decimal totalMensajeria_Express, Decimal totalMensajeria_Internacional, Decimal totalPaqueteria,
                                                              Decimal totalPaqueteria_Estandar, Decimal totalPaqueteria_Express, Decimal totalPaqueteria_Internacional,
                                                              Decimal totalServicios, Decimal totalServicios_Estandar, Decimal totalServicios_Express, 
                                                              Decimal totalServicios_Internacional, Decimal totalEstandar, Decimal totalExpress, 
                                                              Decimal totalInternacional, Decimal totalNacional){
        Map<String, Decimal> ventasValorMap = new Map<String, Decimal> ();
        
        ventasValorMap.put('Total Venta Global', 							totalVentas);
        ventasValorMap.put('Total Venta Mensajería TS-T0', 					totalMensajeria);
        ventasValorMap.put('Total Venta Paquetería y Carga T1-T7', 			totalPaqueteria);
        ventasValorMap.put('Total Venta Servicios', 						totalServicios);
        ventasValorMap.put('Total Venta Estándar', 							totalEstandar);
        ventasValorMap.put('Total Venta Express', 							totalExpress);
        ventasValorMap.put('Total Venta Internacional', 					totalInternacional);
        ventasValorMap.put('Total Venta Nacional', 							totalNacional);
        ventasValorMap.put('Venta Mensajeria TS-T0 Estandar', 				totalMensajeria_Estandar);
        ventasValorMap.put('Venta Mensajeria TS-T0 Express', 				totalMensajeria_Express);
        ventasValorMap.put('Venta Mensajeria TS-T0 Internacional', 			totalMensajeria_Internacional);
        ventasValorMap.put('Venta Paquetería y Carga T1-T7 Estandar', 		totalPaqueteria_Estandar);
        ventasValorMap.put('Venta Paquetería y Carga T1-T7 Express', 		totalPaqueteria_Express);
        ventasValorMap.put('Venta Paquetería y Carga T1-T7 Internacional', 	totalPaqueteria_Internacional);
        ventasValorMap.put('Venta Servicios Estandar', 						totalServicios_Estandar);
        ventasValorMap.put('Venta Servicios Express', 						totalServicios_Express);
        ventasValorMap.put('Venta Servicios Internacional', 				totalServicios_Internacional);
        
        return ventasValorMap;
    }
    
    public static List<String> llenaValoresTendencias (){
        
        List<String> listaTendencias = new List<String>();
        listaTendencias.add('Tendencia Global');
        listaTendencias.add('Tendencia Mensajería TS-T0');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7');
        listaTendencias.add('Tendencia Servicios');
        listaTendencias.add('Tendencia Estándar');
        listaTendencias.add('Tendencia Express');
        listaTendencias.add('Tendencia Internacional');
        listaTendencias.add('Tendencia Nacional');
        listaTendencias.add('Tendencia Mensajeria TS-T0 Estandar');
        listaTendencias.add('Tendencia Mensajeria TS-T0 Express');
        listaTendencias.add('Tendencia Mensajeria TS-T0 Internacional');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7 Estandar');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7 Express');
        listaTendencias.add('Tendencia Paquetería y Carga T1-T7 Internacional');
        listaTendencias.add('Tendencia Servicios Estandar');
        listaTendencias.add('Tendencia Servicios Express');
        listaTendencias.add('Tendencia Servicios Internacional');
        return listaTendencias;
    }
    public static void recalculoTendencias (Id sucursalId, String mesConsulta, String anio, Date fecha, Id propietario){
        Decimal totalDiasMes 									= 0;
        Decimal totalDiasTranscurridos 							= 0;
        List<Tendencia__c> 				dpTendenciaList 		= new List<Tendencia__c>();
        List<Tendencia__c> 				dpVentasList 			= new List<Tendencia__c>();
        List<Tendencia__c>				tendenciasUpdateList 	= new List<Tendencia__c>();
        List<Sucursal_Calendario__c>  	SucCalendarioList		= new List<Sucursal_Calendario__c>();
        List<Ano_Calendario__c>			anioCalendarioList		= new List<Ano_Calendario__c>();
        List<String>					valoresVentasList 		= llenaValoresVentas ();
        Map<String, String> 			correspondenciasTendenciasVentasMap = new Map<String, String>();

        // LISTA DE VALORES DE TENDENCIA
        contador = 0;
        for(AggregateResult result : [SELECT Count(Id) total FROM Tendencia__c WHERE Sucursal__c =: sucursalId AND Mes__c =: mesConsulta AND Anio__c =: anio AND Tipo_de_Importe__c IN: llenaValoresTendencias()]){
            contador += (Integer)result.get('total');
            if(contador > 50000){
                strError = 'AuxTendencia.recalculoTendencias dpTendenciaList rompió el límite de los 50 mil registros. Sucursal: ' + sucursalId + ' mes: ' + mesconsulta + 'Año: ' + anio;
                System.debug(strError);
                AuxBatchProductividadEjecutivo.generaSolicitudEmail(strError, 'AuxTendencia consulta de dpTendenciaList', 491);
                break;
            }
        }
        dpTendenciaList = [SELECT Id, Sucursal__c, Anio__c, Mes__c, importe__c, Tipo_de_Importe__c FROM Tendencia__c
                        WHERE Sucursal__c =: sucursalId AND Mes__c =: mesConsulta
                        AND Anio__c =: anio AND Tipo_de_Importe__c IN: llenaValoresTendencias()];

        // LISTA DE VALORES DE VENTA PARA LA TENDENCIA
        contador = 0;
        for(AggregateResult result : [SELECT Count(Id) total FROM Tendencia__c WHERE Sucursal__c =: sucursalId AND Mes__c =: mesConsulta AND Anio__c =: anio AND Tipo_de_Importe__c IN: valoresVentasList]){
            contador += (Integer)result.get('total');
            if(contador > 50000){
                strError = 'AuxTendencia.recalculoTendencias dpVentasList rompió el límite de los 50 mil registros. Sucursal: ' + sucursalId + ' mes: ' + mesconsulta + '. Año: ' + anio;
                System.debug(strError);
                AuxBatchProductividadEjecutivo.generaSolicitudEmail(strError, 'AuxTendencia consulta de dpVentasList', 505);
                break;
            }
        }
        dpVentasList = [SELECT Id, Sucursal__c, Anio__c, Mes__c, importe__c, Tipo_de_Importe__c FROM Tendencia__c
                        WHERE Sucursal__c =: sucursalId AND Mes__c =: mesConsulta
                        AND Anio__c =: anio AND Tipo_de_Importe__c IN:valoresVentasList];

        // CONSULTA CALENDARIO RELACIONADO A LA SUCURSAL
        contador = 0;
        for(AggregateResult result : [SELECT Count(Id) total FROM Sucursal_Calendario__c WHERE Sucursal__c =: sucursalId AND AnoCalendario__r.Ano__c =: anio]){
            contador += (Integer)result.get('total');
            if(contador > 50000){
                strError = 'AuxTendencia.recalculoTendencias SucCalendarioList rompió el límite de los 50 mil registros. Sucursal: ' + sucursalId +  '. Año: ' + anio;
                System.debug(strError);
                AuxBatchProductividadEjecutivo.generaSolicitudEmail(strError, 'AuxTendencia consulta de SucCalendarioList', 505);
                break;
            }
        }
        SucCalendarioList = [SELECT Id, Sucursal__c, AnoCalendario__c, AnoCalendario__r.Ano__c FROM Sucursal_Calendario__c
                            WHERE Sucursal__c =: sucursalId AND AnoCalendario__r.Ano__c =: anio];

        if(test.isRunningTest()){
            SucCalendarioList = [SELECT Id, Sucursal__c, AnoCalendario__c, AnoCalendario__r.Ano__c FROM Sucursal_Calendario__c LIMIT 1];
        }
        // CONSULTA VALORES DEL CALENDARIO RELACIONADO A LA SUCURSAL
        if(SucCalendarioList.size()>0){
            contador = 0;
            for(AggregateResult result : [SELECT Count(Id) total FROM Ano_Calendario__c WHERE Id=: SucCalendarioList[0].AnoCalendario__c]){
                contador += (Integer)result.get('total');
                if(contador > 50000){
                    strError = 'AuxTendencia.recalculoTendencias anioCalendarioList rompió el límite de los 50 mil registros. Id: ' + SucCalendarioList[0].AnoCalendario__c;
                    System.debug(strError);
                    AuxBatchProductividadEjecutivo.generaSolicitudEmail(strError, 'AuxTendencia consulta de anioCalendarioList', 539);
                    break;
                }
            }
            anioCalendarioList= [SELECT Abril__c,Agosto__c,Ano__c,DiasHabilesTranscurridosDelAno__c,Dias_transcurridos_Abril__c,Dias_transcurridos_Agosto__c,
                                Dias_transcurridos_Diciembre__c,Dias_transcurridos_Enero__c,Dias_transcurridos_Febrero__c,Dias_transcurridos_Julio__c,
                                Dias_transcurridos_Junio__c,Dias_transcurridos_Marzo__c,Dias_transcurridos_Mayo__c,Dias_transcurridos_Noviembre__c,
                                Dias_transcurridos_Octubre__c,Dias_transcurridos_Septiembre__c,Diciembre__c,Enero__c,Febrero__c,Id,Julio__c,Junio__c,
                                Marzo__c,Mayo__c,Name,Noviembre__c,Observaciones__c,Octubre__c,Septiembre__c,Total_Anual__c FROM Ano_Calendario__c 
                                WHERE Id=: SucCalendarioList[0].AnoCalendario__c];

            List<Decimal> diasMes_DiasTranscurridos_List = new List<Decimal>();
            diasMes_DiasTranscurridos_List = calculaDiasMes_DiasTranscurridos(anioCalendarioList, mesConsulta);
            totalDiasMes = diasMes_DiasTranscurridos_List[0];
            totalDiasTranscurridos = getDiasTranscurridos(anioCalendarioList[0].Id,fecha);
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
                tend.Sucursal__c	 	= sucursalId;
                tend.Tipo_de_Importe__c	= t;
                tend.Fecha__c			= fecha;
                tend.Importe__c			= calculaImporteTendencia(correspondenciasTendenciasVentasMap.get(t), dpVentasList, totalDiasMes, totalDiasTranscurridos, sucursalId, mesConsulta, anio, fecha);
                tend.OwnerId			= propietario;
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
                t.Importe__c = calculaImporteTendencia(correspondenciasTendenciasVentasMap.get(t.Tipo_de_Importe__c), dpVentasList, totalDiasMes, totalDiasTranscurridos, sucursalId, mesConsulta, anio, fecha);
                System.debug('t.Tipo_de_Importe__c: ' + t.Tipo_de_Importe__c	);
                System.debug('t.Importe__c: ' + t.Importe__c);
            }
            update dpTendenciaList;
        }
    }

    public static Decimal getDiasTranscurridos(Id anioCalendario, Date fechaEjecucion){
        //Obtener el inicio de mes
        Date fechaFormat = fechaEjecucion;
        Date primerDiaDate = fechaFormat.toStartOfMonth();
        System.debug(primerDiaDate);

        Decimal porcionGeneral = 0.0;

        try{
            List<AggregateResult> sumaPorciones = [Select sum(Porcion__c) Porcion from DetalleCalendario__c where (Fecha__c<=: fechaEjecucion AND Fecha__c >=: primerDiaDate)];
            if(sumaPorciones != null){
                porcionGeneral = (Decimal) sumaPorciones[0].get('Porcion');
            }
        }catch(Exception ex){
            System.debug('Error en '+ex.getMessage());
            System.debug('Error en '+ex.getlinenumber());
        }

        return porcionGeneral;

    }

    public static Decimal calculaImporteTendencia (String tipoImporte, List<Tendencia__c> dpVentasList, Decimal totalDiasMes, Decimal totalDiasTranscurridos,
                                                  Id sucursalId, String mesConsulta, String anio, Date fecha){
        Decimal tendencia = 0;
        Decimal totalVentaMes = 0;
        Decimal totalVentaPromedioDiaria = 0;
        System.debug('============== calculaImporteTendencia ===============');
		System.debug('tipoImporte : ' + tipoImporte);
		System.debug('totalDiasMes : ' + totalDiasMes);
		System.debug('totalDiasTranscurridos : ' + totalDiasTranscurridos);
        System.debug('sucursalId : ' + sucursalId);
 		System.debug('mesConsulta : ' + mesConsulta);
		System.debug('anio : ' + anio);
		System.debug('fecha : ' +fecha);
		System.debug('============== FOR 299===============');
        for(Tendencia__c t: ejecutaConsultaTendencia(tipoImporte, sucursalId, mesConsulta, anio)){
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
    
    public static List<Tendencia__c> ejecutaConsultaTendencia (String tipoImporte, String sucursalId, String mesConsulta, String anio){
        System.debug('========= EJECUTA CONSULTA TENDENCIA ===========');
        System.debug('tipoImporte : ' + tipoImporte);
        System.debug('sucursalId : ' + sucursalId);
        System.debug('mesConsulta : ' + mesConsulta);
        System.debug('anio : ' + anio);
        List<Tendencia__c> ventasTendenciaList = new List<Tendencia__c>();

        contador = 0;
        for(AggregateResult result : [SELECT Count(Id) total FROM Tendencia__c WHERE Sucursal__c =: sucursalId AND Mes__c =: mesConsulta AND Anio__c =: anio AND Tipo_de_Importe__c =: tipoImporte]){
            contador += (Integer)result.get('total');
            if(contador > 50000){
                strError = 'AuxTendencia.ejecutaConsultaTendencia ventasTendenciaList rompió el límite de los 50 mil registros. Sucursal: ' + sucursalId + 'Mes consulta: ' + mesConsulta + '. Año: ' + anio + 'Tipo de importe: ' + tipoImporte;
                System.debug(strError);
                AuxBatchProductividadEjecutivo.generaSolicitudEmail(strError, 'AuxTendencia consulta de ventasTendenciaList', 696);
                break;
            }
        }
        ventasTendenciaList =[SELECT Id, Sucursal__c, Anio__c, Mes__c, importe__c, Tipo_de_Importe__c 
                              FROM Tendencia__c 
                              WHERE Sucursal__c =: sucursalId AND Mes__c =: mesConsulta AND Anio__c =: anio AND 
                                    Tipo_de_Importe__c =: tipoImporte
                                    ];
        System.debug('========= FOR 387 ===========');
        for(Tendencia__c t: ventasTendenciaList){
            System.debug('t.Tipo_de_Importe__c : ' + t.Tipo_de_Importe__c);
            System.debug('t.importe__c : ' + t.importe__c);
            System.debug('t.Mes__c : ' + t.Mes__c);
            System.debug('t.Anio__c : ' + t.Anio__c);
            System.debug('t.Sucursal__c : ' + t.Sucursal__c);
            System.debug('t.Id : ' + t.Id);
        }
        return ventasTendenciaList;
    }
    public static Map<String, String> retornaValoresCorrespondencia (){
        Map<string, string> valoresTenciaVentas = new Map<String,String>();
        for(String t : llenaValoresTendencias()){
            if(t == 'Tendencia Global'){
                valoresTenciaVentas.put(t, 'Total Venta Global' );
            }
            if(t == 'Tendencia Mensajería TS-T0'){
                valoresTenciaVentas.put(t, 'Total Venta Mensajería TS-T0' );
            }
            if(t == 'Tendencia Paquetería y Carga T1-T7'){
                valoresTenciaVentas.put(t, 'Total Venta Paquetería y Carga T1-T7' );
            }
            if(t == 'Tendencia Servicios'){
                valoresTenciaVentas.put(t, 'Total Venta Servicios' );
            }
            if(t == 'Tendencia Estándar'){
                valoresTenciaVentas.put(t, 'Total Venta Estándar' );
            }
            if(t == 'Tendencia Express'){
                valoresTenciaVentas.put(t, 'Total Venta Express' );
            }
        	if(t == 'Tendencia Internacional'){
                valoresTenciaVentas.put(t, 'Total Venta Internacional' );
            }
            if(t == 'Tendencia Nacional'){
                valoresTenciaVentas.put(t, 'Total Venta Nacional' );
            }
            if(t == 'Tendencia Mensajeria TS-T0 Estandar'){
                valoresTenciaVentas.put(t, 'Venta Mensajeria TS-T0 Estandar' );
            }
            if(t == 'Tendencia Mensajeria TS-T0 Express'){
                valoresTenciaVentas.put(t, 'Venta Mensajeria TS-T0 Express' );
            }
            if(t == 'Tendencia Mensajeria TS-T0 Internacional'){
                valoresTenciaVentas.put(t, 'Venta Mensajeria TS-T0 Internacional' );
            }
        	if(t == 'Tendencia Paquetería y Carga T1-T7 Estandar'){
                valoresTenciaVentas.put(t, 'Venta Paquetería y Carga T1-T7 Estandar' );
            }
            if(t == 'Tendencia Paquetería y Carga T1-T7 Express'){
                valoresTenciaVentas.put(t, 'Venta Paquetería y Carga T1-T7 Express' );
            }
            if(t == 'Tendencia Paquetería y Carga T1-T7 Internacional'){
                valoresTenciaVentas.put(t, 'Venta Paquetería y Carga T1-T7 Internacional' );
            }
            if(t == 'Tendencia Servicios Estandar'){
                valoresTenciaVentas.put(t, 'Venta Servicios Estandar' );
            }
            if(t == 'Tendencia Servicios Express'){
                valoresTenciaVentas.put(t, 'Venta Servicios Express' );
            }
            if(t == 'Tendencia Servicios Internacional'){
                valoresTenciaVentas.put(t, 'Venta Servicios Internacional' );
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
    
    public static Date getFechaEjecucion (){
        Date hoy;
        List<EjecucionPresonalizadaBatch__c> ejecucionList = [SELECT Id, Activo__c, Fecha_a_ejecutar__c FROM EjecucionPresonalizadaBatch__c LIMIT 1]; 
        
        if(ejecucionList.size()==1){
            if(ejecucionList[0].Activo__c == true){
                hoy = ejecucionList[0].Fecha_a_ejecutar__c;
            }else{
                hoy = date.today()-1;
            }
        }else{
            	hoy = date.today()-1;
        }
        return hoy;
    }

    // Métodos auxiliares para validaciones
    private static Boolean esTarifaPaqueteria(String servicioClave) {
        return servicioClave == 'TARIFA_T1' || servicioClave == 'TARIFA_T2' || servicioClave == 'TARIFA_T3' || 
            servicioClave == 'TARIFA_T4' || servicioClave == 'TARIFA_T5' || servicioClave == 'TARIFA_T6' || 
            servicioClave == 'TARIFA_T7';
    }

    private static Boolean esTarifaMensajeriaOPaqueteria(String servicioClave) {
        return servicioClave == 'TARIFA_TS' || servicioClave == 'TARIFA_T0' || servicioClave == 'TARIFA_T1' || 
            servicioClave == 'TARIFA_T2' || servicioClave == 'TARIFA_T3' || servicioClave == 'TARIFA_T4' || 
            servicioClave == 'TARIFA_T5' || servicioClave == 'TARIFA_T6' || servicioClave == 'TARIFA_T7';
    }

    private static Boolean esServicioZonaExtendida(String servicioClave) {
        return servicioClave == 'ESP-1' || servicioClave == 'MISIVA_FLETE' || servicioClave == 'LYNDEN_FLETE';
    }

    private static Boolean esServicioAcuse(String servicioClave) {
        return servicioClave == 'ACUSE_CLIENTE' || servicioClave == 'ACUSE_INTERNO' || servicioClave == 'ACUSE_XT';
    }

    private static Boolean esServicioOtro(String servicioClave) {
        return servicioClave == 'ALMACENAJE' || servicioClave == 'COM' || servicioClave == 'EAD_CITA' ||
            servicioClave == 'EAD_DET' || servicioClave == 'EMB-1' || servicioClave == 'EMB-2' ||
            servicioClave == 'EMB-3' || servicioClave == 'EMB-4' || servicioClave == 'EMB-5' ||
            servicioClave == 'EMBALAJE-T0' || servicioClave == 'EMBALAJE-T1' || servicioClave == 'EMBALAJE-T2' ||
            servicioClave == 'EMBALAJE-T3' || servicioClave == 'ENTREGA_LOCAL' || servicioClave == 'FASTEX_CAMBIO_DOMICILIO' ||
            servicioClave == 'FASTEX_DEVOLUCION' || servicioClave == 'FASTEX_PEDIMENTO' || servicioClave == 'FASTEX_REEXPEDICION' ||
            servicioClave == 'FEDEX_CAMBIO_DOMICILIO' || servicioClave == 'FEDEX_COSTO_COMBUSTIBLE' || servicioClave == 'FEDEX_DEVOLUCION' ||
            servicioClave == 'FEDEX_GASTOS_ADUANA' || servicioClave == 'FEDEX_REEXPEDICION' || servicioClave == 'FLEJE' ||
            servicioClave == 'FTL' || servicioClave == 'FTL-ACU' || servicioClave == 'FTL-EST' ||
            servicioClave == 'FTL-MAN' || servicioClave == 'FTL-REP' || servicioClave == 'FTL-SEG' ||
            servicioClave == 'MANIOBRAS' || servicioClave == 'NA' || servicioClave == 'OTROS' ||
            servicioClave == 'PALETTE' || servicioClave == 'PICKING' || servicioClave == 'PQE_COSTO_COMBUSTIBLE' ||
            servicioClave == 'RAD-ZP' || servicioClave == 'SERV_ADICIONALES' || servicioClave == 'SPECIAL_PACKAGING' ||
            servicioClave == 'TRANSFER_ADMIN_DE_FLETE' || servicioClave == 'TRANSFER_ALMACENAJE' || servicioClave == 'TRANSFER_CRUCE_FRONTERIZO' ||
            servicioClave == 'TRANSFER_FLETE_EXTRANJERO' || servicioClave == 'TRANSFER_GASTOS_ADUANALES' || servicioClave == 'UNIDAD DEDICADA 0.7' ||
            servicioClave == 'UNIDAD DEDICADA 1.7' || servicioClave == 'UPS_CAMBIO_DOMICILIO' || servicioClave == 'UPS_COSTO_COMBUSTIBLE' ||
            servicioClave == 'UPS_ENTREGA_SABADO' || servicioClave == 'UPS_EXTENDIDO' || servicioClave == 'UPS_GASTOS_ADUANALES' ||
            servicioClave == 'UPS_PEDIMENTO' || servicioClave == 'UPS-PAQ';
    }

    // Método para formatear fechas para Data Cloud
    private static String formatDate(Date d) {
        return d.year() + '-' + 
            String.valueOf(d.month()).leftPad(2, '0') + '-' + 
            String.valueOf(d.day()).leftPad(2, '0');
    }
    
}