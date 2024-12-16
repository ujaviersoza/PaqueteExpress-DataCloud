/**
 * Modificó: Salvador Ramírez (sramirez@freewayconsulting.com). Fecha: 12/04/2022. Caso: 6596. Se genera un nuevo caso para poder generar una nueva regla de colaboración para que los gerentes de sucursal puedan visualizar las cuentas de su sucursal
 * Modificó: Salvador Ramírez (sramirez@freewayconsulting.com). Fecha: 25/05/2022. Se agrega llamado a clase ValidaRFC para llamar WS que valide que el RFC sea correcto.
 * Modificó: Salvador Ramírez (sramirez@freewayconsulting.com). Fecha: 21/07/2022. Se elimina llamado a clase ValidaRFC ya que no será necesario validar el RFC, cambió el proceso
**/
public class TriggerCuenta {
    public Static Boolean blnRFCValido;
	public static void genera_Gerente_KAM(List<Account> accList){
        Set<Id> sucursalesId = new Set<Id>();
        String nameUser='', nameUserFilter='';
		List<Estructura__c> estructurasList = new List<Estructura__c>();
        List<Estructura__c> estructuraUser = new List<Estructura__c>();
        List<User> PlazaUser = new List<User>();
        List<String> Plazas = new List<String>();

        //Sucursales evaluación previa Division norte
        String SucAsesores = System.Label.SucursalesAsesores;
        String [] ArraySucAsesores = SucAsesores.split(';');

        nameUser = UserInfo.getName();//Nombre usuario referencia para asignacion  de KAM_Regional__c

        nameUserFilter = CuentaHelper.depuraCadena(nameUser);

        for(Account acc: accList){
            //REQ CC Vista de lista CA10986
            if(!String.isBlank(acc.ParentId)){
                //Caso Vista de lista CA10986
                acc.Cuenta_relacionada__c = acc.ParentId;
            }
            if(acc.Sucursal__c != null){
                sucursalesId.add(acc.Sucursal__c);
                System.debug('Sucursallll '+acc.Sucursal__c);
            }
        }
        if(sucursalesId.size()>0){           

            estructurasList = [SELECT Id, Sucursal__c,Sucursal__r.Name, Gerente_Sucursal__c, KAM_regional__c, Gerente_desarrollo_de_negocios__c FROM Estructura__c WHERE Sucursal__c IN: sucursalesId];
            if(estructurasList.size()>0){
                Map<Id, Estructura__c> idSucursalWEstructura=  new Map<Id, Estructura__c>();
                for(estructura__c est: estructurasList){
                    idSucursalWEstructura.put(est.Sucursal__c, est);
                }

                //Sucursales evaluación previa Division norte               
                Boolean enrutadoKAM_Norte = false;
                String kamNorte='';
               
                Boolean enrutadoKAM = false;
                String kam='';
            	for(Account acc: accList){                    
                    System.debug('Previo a Evaluacion');                   

                    if(ArraySucAsesores.contains(acc.Sucursal__c)){
                        FW_Asesores_Division_Norte__mdt mcNorte = FW_Asesores_Division_Norte__mdt.getInstance(nameUserFilter);
                        if(mcNorte!=null){     
                            enrutadoKAM_Norte = true;  
                            kamNorte = mcNorte.Id_Usuario__c;                                                                  
                        }
                    }

                    if(!enrutadoKAM_Norte){
                        System.debug('El nameFilter '+nameUserFilter);
                        FW_Asesores__mdt mcMEXCentro = FW_Asesores__mdt.getInstance(nameUserFilter);
                        if(mcMEXCentro!=null){
                            enrutadoKAM = true;
                            kam = mcMEXCentro.Id_Usuario__c;
                        }
                    }

                    if(idSucursalWEstructura.containsKey(acc.Sucursal__c)){
                        Estructura__c estLocal = idSucursalWEstructura.get(acc.Sucursal__c);
                        acc.Gerente_de_sucursal__c = estLocal.Gerente_Sucursal__c;
                        System.debug('EL KAM '+kam + 'kam localold '+estLocal.KAM_regional__c);
                        if(enrutadoKAM){
                            acc.KAM_Regional__c =  kam;                            
                        }
                        if(enrutadoKAM_Norte){
                            acc.KAM_Regional__c =  kamNorte;
                        }

                        if(!enrutadoKAM && !enrutadoKAM_Norte){
                            acc.KAM_Regional__c = estLocal.KAM_regional__c;
                        }                        
                        acc.Gerente_de_Desarrollo_de_Negocios__c = estLocal.Gerente_desarrollo_de_negocios__c;
                    }  
                    //Reset de banderas de asignación de KAM
                    enrutadoKAM = false;
                    enrutadoKAM_Norte = false;
                }
            }
        }
        //Asigna gerente, kam y gdn para el usuario que se quiere asignar
		for(Account acc: accList){
            if(acc.Usuario_a_asignar__c != null){
                System.debug('Usuario a asignar '+acc.Usuario_a_asignar__c);
				PlazaUser = [SELECT Id, Plaza__c,Name FROM User WHERE Id=: acc.Usuario_a_asignar__c];
                System.debug('datos: ' + acc.Usuario_a_asignar__c);
                if(PlazaUser.size() > 0){
                    Plazas.add(PlazaUser[0].Plaza__c);
                }
            }
        }
        if(Plazas.size()>0){
            // nameUser = UserInfo.getName();//Nombre usuario referencia para asignacion  de KAM_Regional__c
            // nameUserFilter = nameUser.replace(' ','_');

            estructuraUser = [SELECT Id, Gerente_Sucursal__c,Sucursal__c,Sucursal__r.Name, KAM_regional__c, Gerente_desarrollo_de_negocios__c, Plaza_sucursal__c FROM Estructura__c WHERE Plaza_sucursal__c IN: Plazas];
            System.debug('Plazas de estructuras encontradas: ' + estructuraUser.size());
            if(estructuraUser.size()>0){
                for(Account acc: accList){
                    System.debug('Plaza del usuario: ' + PlazaUser[0].Plaza__c);
                    for(estructura__c est: estructuraUser){                        
                        Boolean aplicaDivNorte = false;
                        System.debug('INFO OBSSSS');
                        system.debug('Usuario asignar '+acc.Usuario_a_asignar__c);
                        system.debug('Plaza user [0] '+PlazaUser[0].Id);
                        system.debug('Plaza user Plaza '+PlazaUser[0].Plaza__c);
                        system.debug('Usuario Est plaza sucursal '+est.Plaza_sucursal__c);
                        system.debug('Kam regional_user__c'+acc.KAM_Regional_User__c);
                        system.debug('est Kam regional_user__c'+est.KAM_regional__c);
                        

                        if(acc.Usuario_a_asignar__c == PlazaUser[0].Id && PlazaUser[0].Plaza__c == est.Plaza_sucursal__c){
                            System.debug('Realiza asiganción'+PlazaUser[0].Name);
                    		acc.Gerente_de_Sucursal_User__c = est.Gerente_Sucursal__c;
                            String kamUser = CuentaHelper.getKamUser(PlazaUser[0].Name);
                            System.debug('EL KamUser '+kamUser);
                    		acc.KAM_Regional_User__c = !String.isBlank(kamUser) ? kamUser : est.KAM_regional__c;
                    		acc.GDN_User__c = est.Gerente_desarrollo_de_negocios__c;

                            //Se verifica que el KAM corresponde a esa sucursal
                            //Nueva forma con etiquetas                            
                            if(ArraySucAsesores.contains(Est.Sucursal__c)){
                                FW_Asesores_Division_Norte__mdt mc = FW_Asesores_Division_Norte__mdt.getInstance(nameUserFilter);
                                if(mc!=null){                                   
                                    acc.KAM_regional__c = mc.Id_Usuario__c;
                                    aplicaDivNorte = true;
                                }
                            }

                            //Sucursales caso 8209 Configuracion MEX01

                            System.debug('El nameFilter '+nameUserFilter);
                            if(!aplicaDivNorte){
                                FW_Asesores__mdt mcMEXCentro = FW_Asesores__mdt.getInstance(nameUserFilter);
                                if(mcMEXCentro!=null){
                                    acc.KAM_regional__c = mcMEXCentro.Id_Usuario__c;
                                }          
                            }
                        }
                    }
                }
            }
        }
    }
    public static void AsignacionEjecutivoNuevo (List<Account> accList, Map<Id, Account> accOldMap){

        String razonSocial;
        String RFC;
        String IdSipweb;
        String Plaza;

		List<String> args = new String[]{'0','number','###,###,##0.00'};
        System.debug('Lista accList ' +accList);
        System.debug('accOldMap ' +accOldMap);
        for(Account acc: accList){
            
            Decimal promedioMensual;
            Account AccOld = accOldMap.get(Acc.Id);
            
            Integer posiciones  = 0;
            if(acc.Name.length()>= 10){posiciones = 10;}else{posiciones = acc.Name.length();}
            razonSocial = acc.Name.substring(0, posiciones);
            if(razonSocial.endsWith(' ')){razonSocial = acc.Name.substring(0, 9);    if(razonSocial.endsWith(' ')){razonSocial = acc.Name.substring(0, 8);    }}
            RFC			= acc.RFC__c;
            IdSipweb 	= acc.Id_SIpWeb__c;
            Plaza = [SELECT Id, Plaza__c FROM Sucursal__c WHERE Id =: acc.Sucursal__c].Plaza__c;
          
            System.debug('acc.AsignacionRegular_Mantenimiento__c: ' + acc.AsignacionRegular_Mantenimiento__c);
            System.debug('AccOld.AsignacionRegular_Mantenimiento__c: ' + AccOld.AsignacionRegular_Mantenimiento__c);
            System.debug('AccOld.AsignarEjecutivoACuentaEnSipweb__c ' + AccOld.AsignarEjecutivoACuentaEnSipweb__c);
            System.debug('acc.AsignarEjecutivoACuentaEnSipweb__c: ' + acc.AsignarEjecutivoACuentaEnSipweb__c);
            System.debug('acc.AsignacionRegular_Nuevo__c ' + acc.AsignacionRegular_Nuevo__c);
            System.debug('acc.RFC__c: ' + acc.RFC__c);
            System.debug('acc.Preasignar_Ejecutivo__c: ' + acc.Preasignar_Ejecutivo__c);
            System.debug('AccOld.Preasignar_Ejecutivo__c: ' + AccOld.Preasignar_Ejecutivo__c);
            System.debug('Usuario que detona el flujo: '+ UserInfo.getProfileId());

            if(acc.OwnerId == UserInfo.getUserId() && UserInfo.getProfileId() == '00e2E0000016QlkQAE'){
                acc.Usuario_a_asignar__c = acc.OwnerId;
            }

            if(acc.Preasignar_Ejecutivo__c != AccOld.Preasignar_Ejecutivo__c && acc.Preasignar_Ejecutivo__c == true ){
                //system.debug('ENTRA  PREASIGNACION IF 47');
                acc.OwnerId = acc.Usuario_a_asignar__c;
                acc.Preasignar_Ejecutivo__c = false;
            }else if (acc.Preasignacion_Mantenimiento__c != AccOld.Preasignacion_Mantenimiento__c && acc.Preasignacion_Mantenimiento__c == true ){
                system.debug('ENTRA  PREASIGNACION IF 47');
            }else{
                //INTERNACIONAL
                if(acc.AsignarEjecutivoACuentaEnSipweb__c != AccOld.AsignarEjecutivoACuentaEnSipweb__c
                   && acc.AsignarEjecutivoACuentaEnSipweb__c == true && acc.Asignacion_Internacional__c == true
                   && acc.MigracionPrepagoADocumentacionEnLinea__c == false && acc.RFC__c != '' && acc.RFC__c != null){
                       if(getValidacionTareas(acc.Id, acc.Usuario_a_asignar__c, acc.CreatedDate) == false){
                           acc.addError('No hay suficientes registros que justifiquen su asignación');
                       }
                   }
                //PREPAGO
                if(acc.AsignarEjecutivoACuentaEnSipweb__c != AccOld.AsignarEjecutivoACuentaEnSipweb__c
                   && acc.AsignarEjecutivoACuentaEnSipweb__c == true && acc.AsignacionNacionalPrepago__c == true
                   && acc.MigracionPrepagoADocumentacionEnLinea__c == false && acc.RFC__c != '' && acc.RFC__c != null){
                       if(getValidacionTareas(acc.Id, acc.Usuario_a_asignar__c, acc.CreatedDate) == false){
                           //acc.addError('No hay suficientes registros que justifiquen su asignación');
                       }
                       if(getValidacionCotizaciones (acc.Id, acc.Usuario_a_asignar__c) == false){
                           //acc.addError('No existen cotizaciones que justifiquen su asignación');
                       }
                   }
                // NUEVO
                if(acc.AsignarEjecutivoACuentaEnSipweb__c != AccOld.AsignarEjecutivoACuentaEnSipweb__c
                   && acc.AsignarEjecutivoACuentaEnSipweb__c == true && acc.AsignacionRegular_Nuevo__c == true
                   && acc.MigracionPrepagoADocumentacionEnLinea__c == false && acc.RFC__c != '' && acc.RFC__c != null){
                       
                       Boolean execFuture = true;
                       
                       System.debug('acc.Validacion_Nuevo__c: ' + acc.Validacion_Nuevo__c);
                       
                       if(getValidacionTareas(acc.Id, acc.Usuario_a_asignar__c, acc.CreatedDate) == false){
                           execFuture = false;
                           acc.addError('No hay suficientes registros que justifiquen su asignación');
                       }
                       if(getValidacionCotizaciones (acc.Id, acc.Usuario_a_asignar__c) == false){
                           execFuture = false;
                           acc.addError('No existen cotizaciones que justifiquen su asignación');
                       }
                       
                       if(execFuture)
                           ValidaAsignacionEjecutivoNuevo(razonSocial, RFC, IdSipweb, Plaza, acc.Id);
                       
                   }

                // RECUPERADO
                if(acc.AsignarEjecutivoACuentaEnSipweb__c != AccOld.AsignarEjecutivoACuentaEnSipweb__c
                   && acc.AsignarEjecutivoACuentaEnSipweb__c == true && acc.AsignacionRegular_Recuperado__c == true
                   && acc.RFC__c != '' && acc.RFC__c != null){
                       System.debug('ENTRA VALIDACION RECUPERADO');
                       
                       Boolean execFuture = true;
                       
                        if(getValidacionTareas(acc.Id, acc.Usuario_a_asignar__c, acc.CreatedDate) == false){
                            execFuture = false;
                            acc.addError('No hay suficientes registros que justifiquen su asignación');
                        }
                        if(getValidacionCotizaciones (acc.Id, acc.Usuario_a_asignar__c) == false){
                            execFuture = false;
                            acc.addError('No existen cotizaciones que justifiquen su asignación');
                        }

                       if(execFuture)
                           ValidaAsignacionEjecutivoRecuperado (razonSocial, RFC, IdSipweb, Plaza, acc.Id);
                       
                   }
                // MIGRACION
                if(acc.AsignarEjecutivoACuentaEnSipweb__c != AccOld.AsignarEjecutivoACuentaEnSipweb__c
                   && acc.AsignarEjecutivoACuentaEnSipweb__c == true && acc.AsignacionRegular_Nuevo__c == true
                   && acc.MigracionPrepagoADocumentacionEnLinea__c == true && acc.RFC__c != '' && acc.RFC__c != null){
                       System.debug('ENTRA VALIDACION MIGRACION');
                       Boolean execFuture = true;
                       if(getValidacionTareas(acc.Id, acc.Usuario_a_asignar__c, acc.CreatedDate) == false){
                           execFuture = false;
                           acc.addError('No hay suficientes registros que justifiquen su asignación');
                       }
                       if(getValidacionCotizaciones (acc.Id, acc.Usuario_a_asignar__c) == false){
                           execFuture = false;
                           acc.addError('No existen cotizaciones que justifiquen su asignación');
                       }
                       
                       if(execFuture)
                           ValidaAsignacionEjecutivoMigracion(razonSocial, RFC, IdSipweb, Plaza, acc.Id);
                       
                   }
                //MANTENIMIENTO
                if(acc.AsignarEjecutivoACuentaEnSipweb__c != AccOld.AsignarEjecutivoACuentaEnSipweb__c && acc.AsignarEjecutivoACuentaEnSipweb__c == true  && acc.AsignacionRegular_Mantenimiento__c == true
                   && acc.RFC__c != '' && acc.RFC__c != null ){
                       System.debug('ENTRA VALIDACION MTTO');
                       
                       if(getValidacionTareas(acc.Id, acc.Usuario_a_asignar__c, acc.CreatedDate) == false){		acc.addError('No hay suficientes registros que justifiquen su asignación');
                       }
                       if(getValidacionCotizaciones (acc.Id, acc.Usuario_a_asignar__c) == false){ 	acc.addError('No existen cotizaciones que justifiquen su asignación');
                       }
                       
                       if(acc.Comisi_n_por_Mantenimiento_100__c == false && acc.Comision_diferenciada__c == false && acc.AsignacionRegular_Mantenimiento__c == true){
                       		acc.Comision_directa__c = true;
                       }
                       if(accOld.Comision_directa__c!= acc.Comision_directa__c && acc.Comision_directa__c == true && acc.AsignacionRegular_Mantenimiento__c == true && acc.Porcentaje_de_comision_directa__c == null){
                           acc.Porcentaje_de_comision_directa__c = .50;
                       }
                       system.debug('Porcentaje_de_comision_diferenciada__c: ' + acc.Porcentaje_de_comision_diferenciada__c);
                       system.debug('Porcentaje_de_comision_directa__c: ' + acc.Porcentaje_de_comision_directa__c);
                       if(acc.AsignacionRegular_Mantenimiento__c  == TRUE && ((acc.Comision_diferenciada__c  == TRUE && (acc.Porcentaje_de_comision_diferenciada__c == null || acc.Porcentaje_de_comision_directa__c != null) ))){
                           acc.addError('Si seleccionó Comisión diferenciada introduzca únicamente el porcentaje de comisión diferenciada <= 99%');
                       }else if ( acc.AsignacionRegular_Mantenimiento__c  == TRUE && acc.Comision_directa__c  == TRUE && acc.Porcentaje_de_comision_diferenciada__c != null ){
                           acc.addError('Si seleccionó comisión directa no coloque ningun valor en porcentaje de comisión diferenciada');
                       }else if ( acc.Comision_directa__c  == TRUE && acc.Porcentaje_de_comision_directa__c == null || acc.Porcentaje_de_comision_directa__c == 0){
                           acc.addError('Si seleccionó comisión directa coloque un valor en porcentaje de comisión directa mayor que 0 y menor a 1.5');
                       }
                       else if (acc.Porcentaje_de_comision_diferenciada__c> 99 || acc.Porcentaje_de_comision_directa__c>= 1.5
                                || acc.Porcentaje_de_comision_diferenciada__c<= 0 || acc.Porcentaje_de_comision_directa__c<= 0){
                                    acc.addError('La comisión diferenciada debe ser <= 99% y el porcentaje de comisión directa debe ser <1.5 y mayor que 0 para ambos casos');
                                }
                       
                       getVentaPromedioMensual (razonSocial, RFC, IdSipweb, Plaza, acc.Id);
                       
                   }else{
                       //Validar si se seleccionó mantenimiento, directa. Si %directa= null, guarda 0.5
                       //acc.Porcentaje_de_comision_directa__c = null;
                       if(acc.Comisi_n_por_Mantenimiento_100__c == false && acc.Comision_diferenciada__c == false && acc.AsignacionRegular_Mantenimiento__c == true){acc.Comision_directa__c = true;}
                       if(acc.AsignacionRegular_Mantenimiento__c == true && acc.Comision_directa__c == true && acc.Porcentaje_de_comision_directa__c == null){acc.Porcentaje_de_comision_directa__c = 0.5;}
                   }                
                if(AccOld.Sincronizar_con_SW__c != acc.Sincronizar_con_SW__c && acc.Sincronizar_con_SW__c == true){
                    CallWS_AsignaEjecutivo.callGeneraEjecutivo(acc.Id);
                    acc.AsignarEjecutivoACuentaEnSipweb__c=false;
                }
                if(AccOld.AsignarEjecutivoACuentaEnSipweb__c != acc.AsignarEjecutivoACuentaEnSipweb__c && acc.AsignarEjecutivoACuentaEnSipweb__c == true){
                    CallWS_AsignaEjecutivo.callValidaEjecutivo(acc.Id);
                }
            }
        }
    }
    
    @future(callout= true)
    public static void ValidaAsignacionEjecutivoNuevo (String razonSocial, String RFC, String IdSipweb, String Plaza, String AccountId){
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        Account currentAcc = [SELECT Id,Validacion_Nuevo__c,OmitirValidacionDeInformacion__c,ALERTA_Revisa_su_Venta_existente__c,AsignarEjecutivoACuentaEnSipweb__c,AsignacionRegular_Nuevo__c FROM Account WHERE Id =:AccountId LIMIT 1];
        List<Ventas__dlm> ventasList = new List<Ventas__dlm>();
        List<Opportunity> opportunityList	= new List<Opportunity>();
        Decimal sumaVenta 				= 0;
        Decimal promedioMensualVenta 	= 0;
        Decimal sumaOportunidades		= 0;
        Decimal sumaPromedioOpps		= 0;
        Decimal crecimiento 			= 0;
        Integer numberDays = date.daysInMonth(Date.today().Year(), Date.today().Month()-1);
        Date fechaFin = Date.newInstance(Date.today().Year(), Date.today().Month()-1, numberDays);
        system.debug('END_DATE: ' +  fechaFin);
        Date fechaInicio = Date.newInstance(Date.today().Year(), Date.today().Month()-6, 1);
        system.debug('START_DATE: ' +  fechaInicio);
        Boolean valorDeRetorno;
        System.debug('IdSipweb: ' 		+ IdSipweb);
        System.debug('razonSocial: ' 	+ razonSocial);
        System.debug('RFC: ' 			+ RFC);
        System.debug('fechaInicio: ' 	+ fechaInicio);
        System.debug('fechaFin: ' 		+ fechaFin);
        
        // Traemos las cuentas que coincidan con el RFC y Name
        List<Account> accList = [SELECT Id_SIpWeb__c, Name FROM Account WHERE RFC__c =: RFC AND Name LIKE: '%'+ razonSocial +'%' ];
        System.debug('CCO: '+accList);
        Set<String> accIds = new Set<String>();
        for(Account acc: accList){
            accIds.add(acc.Id_SIpWeb__c);
        }
        
        // Buscamos las ventas que sucursal origen empiecen con el valor de Plaza
        ventasList = [SELECT Id, fecha_venta__c, cliente_origen_clave__c, total_antes_de_impuestos__c, 
                      fecha_id__c, KQ_cliente_origen_clave__c, sucursal_origen_clave__c
                      FROM Ventas__dlm
                      WHERE cliente_origen_clave__c IN: accIds
                      AND fecha_venta__c >=: fechaInicio
                      AND fecha_venta__c <=: fechaFin
                      AND sucursal_origen_clave__c LIKE: Plaza + '%'
                      ORDER BY fecha_venta__c ASC
                     ];
        system.debug('ventasList.size(): ' + ventasList.size());
        if(ventasList.size()==0){
            valorDeRetorno = true;
        }else{
            DateTime getfechePrimeraVenta = DateTime.newInstance(ventasList[0].fecha_venta__c, Time.newInstance(0, 0, 0, 0));
            Date fechaPrimeraVenta = date.newinstance(getfechePrimeraVenta.year(), getfechePrimeraVenta.month(), getfechePrimeraVenta.day());
            Integer mesesAPromediar = fechaPrimeraVenta.monthsBetween(fechaFin);
            system.debug('fechePrimeraVenta: ' +  fechaPrimeraVenta);
            system.debug('fechaFin: ' +  fechaFin);
            system.debug('fechaInicio: ' +  fechaInicio);
            system.debug('Entra validación de mesesAPromediar: ' +  mesesAPromediar);
            if(mesesAPromediar == 0){
                mesesAPromediar = 1;
                System.debug('Nuevo Valor de meses = 1');
            } else {
                System.debug('El valor de meses se queda igual = ' + mesesAPromediar);
            }
            for(Ventas__dlm v: ventasList){sumaVenta += v.total_antes_de_impuestos__c;
                                          }
            System.debug('sumaVenta: ' + sumaVenta);
            promedioMensualVenta = sumaVenta / mesesAPromediar;
            System.debug('promedioMensualVenta: ' + promedioMensualVenta);
            Integer contador =0;
            Date fechaInicioO = System.today().addMonths(-6);
            Date fechaFinO = System.today()+1;
            System.debug('Fecha Inicio O ' + fechaInicioO);
            System.debug('Fecha Fin O ' + fechaFinO);
            for(Opportunity opp: [SELECT Amount, AccountId, Account.Name, Account.RFC__c, CloseDate,
                                  CreatedDate, Account.Id_Sipweb__c, Account.Sucursal__r.Id_SipWeb__c,
                                  Potencial_mensual_MXN__c, StageName
                                  FROM Opportunity
                                  WHERE Account.Id_SIpWeb__c =: IdSipweb
                                  AND CreatedDate >=: fechaInicioO
                                  AND CreatedDate <=: fechaFinO
                                  AND Account.Sucursal__r.Plaza__c =: Plaza
                                  AND StageName = 'Cerrada/Ganada']){
                                      sumaOportunidades += opp.Potencial_mensual_MXN__c;
                                      contador++;
                                  }
            if(contador>0){sumaPromedioOpps = sumaOportunidades / contador;
                          }else{
                              sumaPromedioOpps = 0;
                          }
            System.debug('sumaOportunidades: ' 	+ sumaOportunidades);
            System.debug('contador: ' 			+ contador);
            System.debug('sumaPromedioOpps: ' 	+ sumaPromedioOpps);
            if(promedioMensualVenta > 0){crecimiento = (sumaPromedioOpps / promedioMensualVenta) -1;
                                        } else {
                                            crecimiento = 0;
                                        }
            System.debug('crecimiento: ' 		+ crecimiento);
            if(crecimiento >9){valorDeRetorno = false;
                              }else{
                                  valorDeRetorno = false;
                                  //valorDeRetorno = true;
                              }
        }
        wrapperAsignacionEjecutivoNuevo wAsigEjecNuevo = new wrapperAsignacionEjecutivoNuevo();
        wAsigEjecNuevo.valorDeRetorno = valorDeRetorno;
        wAsigEjecNuevo.promedioVentasMensual = promedioMensualVenta;
        wAsigEjecNuevo.crecimiento = crecimiento * 100;
        System.debug('valorDeRetorno: ' + valorDeRetorno);
        
        currentAcc.Validacion_Nuevo__c = wAsigEjecNuevo.valorDeRetorno;
        
        if(currentAcc.Validacion_Nuevo__c == false && currentAcc.OmitirValidacionDeInformacion__c == false){
            currentAcc.AsignarEjecutivoACuentaEnSipweb__c = false;
            currentAcc.AsignacionRegular_Nuevo__c = false;
            
            currentAcc.ALERTA_Revisa_su_Venta_existente__c ='El cliente ya cuenta con ventas mensuales promedio de $ '+ String.format(wAsigEjecNuevo.promedioVentasMensual.format(), args) +', Si está seguro de avanzar bajo el estatus solicitado, marque la casilla De acuerdo con validación de información';
            
            //acc.addError('El cliente ya cuenta con ventas mensuales promedio de $ '+ String.format(wAsigEjecNuevo.promedioVentasMensual.format(), args) +', Si está seguro de avanzar bajo el estatus solicitado, marque la casilla De acuerdo con validación de información');
        }else {
            if(currentAcc.OmitirValidacionDeInformacion__c == true){
                currentAcc.Validacion_Nuevo__c = true;
            }
            
            System.debug('Crecimiento: ' + wAsigEjecNuevo.crecimiento);
            currentAcc.ALERTA_Revisa_su_Venta_existente__c = '<p style="color:red;">El cliente ya cuenta con ventas mensuales promedio de $ '+ String.format(wAsigEjecNuevo.promedioVentasMensual.format(), args) + ' y crecimiento = ' + wAsigEjecNuevo.crecimiento.setScale(2) + ' %</p>';
        }
        
        update currentAcc;
        
    }
	
    @future(callout= true)
    public static void ValidaAsignacionEjecutivoRecuperado (String razonSocial, String RFC, String IdSipweb, String Plaza, String AccountId){
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        Account currentAcc = [SELECT Id,Validacion_Recuperado__c,OmitirValidacionDeInformacion__c,ALERTA_Revisa_su_Venta_existente__c,AsignarEjecutivoACuentaEnSipweb__c,AsignacionRegular_Recuperado__c FROM Account WHERE Id =:AccountId LIMIT 1];
        Map<Integer, String> valorMes = new Map <Integer, String>();
        Map<String, Decimal> valorVentaMes = new Map <String, Decimal>();
        valorMes.put(1, 'ENERO');
        valorMes.put(2, 'FEBRERO');
        valorMes.put(3, 'MARZO');
        valorMes.put(4, 'ABRIL');
        valorMes.put(5, 'MAYO');
        valorMes.put(6, 'JUNIO');
        valorMes.put(7, 'JULIO');
        valorMes.put(8, 'AGOSTO');
        valorMes.put(9, 'SEPTIEMBRE');
        valorMes.put(10, 'OCTUBRE');
        valorMes.put(11, 'NOVIEMBRE');
        valorMes.put(12, 'DICIEMBRE');
        
        List<Opportunity> opportunityList = new List<Opportunity>();
        
        Decimal sumaVenta = 0;
        Decimal promedioMensualVenta = 0;
        Decimal sumaOportunidades = 0;
        Decimal sumaPromedioOpps = 0;
        Decimal crecimiento = 0;
        
        Integer mesesAPromediar = 6;
        
        Date fechaInicioANIOACTUAL = date.newinstance(Date.today().Year(), 1, 1);
        Date fechaFinANIOACTUAL = date.newinstance(Date.today().Year(), 12, 31);
        Date fechaInicio6MESES = System.today().addMonths(0);
        Date fechaFin6MESES = System.today().addMonths(-6);
        
        Boolean valorDeRetorno;
        
        System.debug('IdSipweb: ' + IdSipweb);
        System.debug('razonSocial: ' + razonSocial);
        System.debug('RFC: ' + RFC);
        System.debug('fechaInicio 6 MESES: ' + fechaInicio6MESES);
        System.debug('fechaFin 6 MESES: ' + fechaFin6MESES);
        
        List<Account> accList = [SELECT Id_SIpWeb__c, Name, Sucursal__r.Plaza__c FROM Account WHERE RFC__c =: RFC AND Name LIKE: '%'+ razonSocial +'%'];
        Set<String> accIds = new Set<String>();
        for(Account acc: accList){
            accIds.add(acc.Id_SIpWeb__c);
        }
        
        // Necesitamos las ventas que pertenezcan a la misma plaza pero sean de distintas cuentas
        List<Ventas__dlm> ventasListOtrosIds = [
            SELECT fecha_venta__c, cliente_origen_clave__c, total_antes_de_impuestos__c
            FROM Ventas__dlm
            WHERE fecha_venta__c <=: fechaInicio6MESES
            AND fecha_venta__c >=: fechaFin6MESES
            AND cliente_origen_clave__c IN: accIds
            AND cliente_origen_clave__c !=: IdSipweb
            AND sucursal_origen_clave__c LIKE: Plaza + '%'
            ORDER BY fecha_venta__c
        ];
        
        system.debug('ventasListOtrosIds.size(): ' + ventasListOtrosIds.size());
        
        List<Ventas__dlm> ventasList6MESES = [
            SELECT fecha_venta__c, cliente_origen_clave__c, total_antes_de_impuestos__c
            FROM Ventas__dlm
            WHERE cliente_origen_clave__c =:IdSipweb
            AND fecha_venta__c <=: fechaInicio6MESES
            AND fecha_venta__c >=: fechaFin6MESES
            AND sucursal_origen_clave__c LIKE: Plaza + '%'
            ORDER BY fecha_venta__c
        ];
        
        system.debug('ventasList6MESES.size(): ' + ventasList6MESES.size());
        
        // Procesar ventas de los últimos 6 meses y agrupar por mes
        Map<Integer, Decimal> monthTotals6Meses = new Map<Integer, Decimal>();
        if(!ventasList6MESES.isEmpty()) {
            for(Ventas__dlm venta : ventasList6MESES) {
                Integer month = venta.fecha_venta__c.month();
                Decimal currentTotal = monthTotals6Meses.get(month);
                if(currentTotal == null) currentTotal = 0;
                monthTotals6Meses.put(month, currentTotal + venta.total_antes_de_impuestos__c);
            }
            
            // Convertir totales a mapa de valores por mes
            for(Integer month : monthTotals6Meses.keySet()) {
                System.debug('MES: ' + month);
                System.debug('VALOR: ' + monthTotals6Meses.get(month));
                valorVentaMes.put(valorMes.get(month), monthTotals6Meses.get(month));
            }
        }
        
        wrapperAsignacionEjecutivoRecuperado wAsigEjecRecuperado = new wrapperAsignacionEjecutivoRecuperado();
        
        if(!monthTotals6Meses.isEmpty()) {
            wAsigEjecRecuperado.valorVentaMes = valorVentaMes;
        }
        
        if(!ventasListOtrosIds.isEmpty()) {
            wAsigEjecRecuperado.otrosIdsConVenta = true;
        } else {
            wAsigEjecRecuperado.otrosIdsConVenta = false;
        }
        
        if(!ventasListOtrosIds.isEmpty() || !ventasList6MESES.isEmpty()) {
            valorDeRetorno = false;
        } else {
            valorDeRetorno = true;
        }
        
        wAsigEjecRecuperado.valorDeRetorno = valorDeRetorno;
        System.debug('valorDeRetorno: ' + valorDeRetorno);
        
        currentAcc.Validacion_Recuperado__c = wAsigEjecRecuperado.valorDeRetorno;
        
        if(currentAcc.Validacion_Recuperado__c == false && currentAcc.OmitirValidacionDeInformacion__c == false){
            
            String mensaje;
            
            if(wAsigEjecRecuperado.valorVentaMes == null && wAsigEjecRecuperado.otrosIdsConVenta== true){
                currentAcc.AsignarEjecutivoACuentaEnSipweb__c = false;
                currentAcc.AsignacionRegular_Recuperado__c = false;
                
                currentAcc.ALERTA_Revisa_su_Venta_existente__c = 'El cliente ya cuenta con ventas mensuales en otros ids de sipweb con la misma razon social, Si está seguro de avanzar bajo el estatus solicitado, marque la casilla De acuerdo con validación de información';
                
            }else if(wAsigEjecRecuperado.valorVentaMes != null && wAsigEjecRecuperado.otrosIdsConVenta== true){
                currentAcc.AsignarEjecutivoACuentaEnSipweb__c = false;
                currentAcc.AsignacionRegular_Recuperado__c = false;
                
                mensaje = 'El cliente ya cuenta con las siguientes 	ventas: ';
                for(String key: wAsigEjecRecuperado.valorVentaMes.keySet()){
                    mensaje+= key +' : $ '+ String.format(  wAsigEjecRecuperado.valorVentaMes.get(key).format(), args) + '. ';
                }
                mensaje += 'y ventas de otros Ids con el mismo nombre de cuenta. ';
                
                currentAcc.ALERTA_Revisa_su_Venta_existente__c = mensaje + 'Si está seguro de avanzar bajo el estatus solicitado, marque la casilla De acuerdo con validación de información';
                
            }else{
                currentAcc.AsignarEjecutivoACuentaEnSipweb__c = false;
                currentAcc.AsignacionRegular_Recuperado__c = false;
                
                mensaje = 'El cliente ya cuenta con las siguientes 	ventas: ';
                for(String key: wAsigEjecRecuperado.valorVentaMes.keySet()){
                    mensaje+= key +' : $ ' +String.format( wAsigEjecRecuperado.valorVentaMes.get(key).format(), args) + '. ';
                }
                
                currentAcc.ALERTA_Revisa_su_Venta_existente__c = mensaje + 'Si está seguro de avanzar bajo el estatus solicitado, marque la casilla De acuerdo con validación de información';
            }
        }
        
        if(currentAcc.OmitirValidacionDeInformacion__c == true){
            String mensaje;
            
            if(wAsigEjecRecuperado.valorVentaMes == null && wAsigEjecRecuperado.otrosIdsConVenta== true){
                mensaje = 'El cliente ya cuenta con ventas mensuales en otros ids de sipweb con la misma razon social';
            }else if(wAsigEjecRecuperado.valorVentaMes != null && wAsigEjecRecuperado.otrosIdsConVenta== true){
                mensaje = 'El cliente ya cuenta con las siguientes 	ventas: ';
                for(String key: wAsigEjecRecuperado.valorVentaMes.keySet()){mensaje+= key +' : $ '+String.format( wAsigEjecRecuperado.valorVentaMes.get(key).format(), args) + '. ';}
                mensaje += 'y ventas de otros Ids con el mismo nombre de cuenta. ';
            }else{
                if(wAsigEjecRecuperado.valorVentaMes != null){
                    mensaje = 'El cliente ya cuenta con las siguientes 	ventas: ';
                    for(String key: wAsigEjecRecuperado.valorVentaMes.keySet()){mensaje+= key +' : $ '+String.format( wAsigEjecRecuperado.valorVentaMes.get(key).format(), args) + '. ';}
                }
            }
            currentAcc.Validacion_Recuperado__c = true;
            currentAcc.ALERTA_Revisa_su_Venta_existente__c  = '<p style="color:red;">' + mensaje +'</p>' ;
            //acc.AnalisisDeValidacion__c  = '<p style="color:red;">' + mensaje +'</p>' ;
        }
        
        update currentAcc;
    }

    @future(callout= true)
    public static void ValidaAsignacionEjecutivoMigracion(String razonSocial, String RFC, String IdSipweb, String Plaza, String AccountId) {
        
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        Account currentAcc = [SELECT Id,Validacion_Nuevo__c,OmitirValidacionDeInformacion__c,ALERTA_Revisa_su_Venta_existente__c,AsignarEjecutivoACuentaEnSipweb__c,AsignacionRegular_Nuevo__c FROM Account WHERE Id =:AccountId LIMIT 1];
        
        wrapperAsignacionEjecutivoRecuperado wAsigEjecMigrado = new wrapperAsignacionEjecutivoRecuperado();
        
        Map<Integer, String> valorMes = new Map<Integer, String>();
        Map<String, Decimal> valorVentaMes = new Map<String, Decimal>();
        valorMes.put(1, 'ENERO');
        valorMes.put(2, 'FEBRERO');
        valorMes.put(3, 'MARZO');
        valorMes.put(4, 'ABRIL');
        valorMes.put(5, 'MAYO');
        valorMes.put(6, 'JUNIO');
        valorMes.put(7, 'JULIO');
        valorMes.put(8, 'AGOSTO');
        valorMes.put(9, 'SEPTIEMBRE');
        valorMes.put(10, 'OCTUBRE');
        valorMes.put(11, 'NOVIEMBRE');
        valorMes.put(12, 'DICIEMBRE');
        
        List<String> valoresConsultaMigracion = new List<String>();
        valoresConsultaMigracion.add('DOCUMLINEA');
        valoresConsultaMigracion.add('ECOMMERCE');
        valoresConsultaMigracion.add('SERVICIOWEB');
        
        Date fechaInicioANIOACTUAL = date.newinstance(Date.today().Year(), 1, 1);
        Date fechaFinANIOACTUAL = date.newinstance(Date.today().Year(), 12, 31);
        Date fechaInicio6MESES = System.today();
        Date fechaFin6MESES = System.today().addMonths(-6);
        
        Boolean valorDeRetorno;
        
        System.debug('IdSipweb: ' + IdSipweb);
        System.debug('razonSocial: ' + razonSocial);
        System.debug('RFC: ' + RFC);
        System.debug('fechaInicio AÑO ACTUAL: ' + fechaInicioANIOACTUAL);
        System.debug('fechaFin AÑO ACTUAL: ' + fechaFinANIOACTUAL);
        System.debug('fechaInicio 6 MESES: ' + fechaInicio6MESES);
        System.debug('fechaFin 6 MESES: ' + fechaFin6MESES);
        
        List<Account> accList = [SELECT Id_SIpWeb__c, Name, Sucursal__r.Plaza__c FROM Account WHERE RFC__c =: RFC AND Name LIKE: '%'+ razonSocial +'%'];
        Set<String> accIds = new Set<String>();
        for(Account acc: accList){
            accIds.add(acc.Id_SIpWeb__c);
        }
        
        // Consulta para año actual
        List<Ventas__dlm> ventasANIOACTUAL = [
            SELECT fecha_venta__c, cliente_origen_clave__c, total_antes_de_impuestos__c, origen_documentacion__c
            FROM Ventas__dlm
            WHERE cliente_origen_clave__c IN: accIds
            AND fecha_venta__c >=: fechaInicioANIOACTUAL
            AND fecha_venta__c <=: fechaFinANIOACTUAL
            AND sucursal_origen_clave__c LIKE: Plaza + '%'
            AND origen_documentacion__c IN: valoresConsultaMigracion
            ORDER BY fecha_venta__c
        ];
        
        system.debug('ventasANIOACTUAL.size(): ' + ventasANIOACTUAL.size());
        
        // Consulta para últimos 6 meses
        List<Ventas__dlm> ventas6MESES = [
            SELECT fecha_venta__c, cliente_origen_clave__c, total_antes_de_impuestos__c, origen_documentacion__c
            FROM Ventas__dlm
            WHERE cliente_origen_clave__c IN :accIds
            AND fecha_venta__c <=: fechaInicio6MESES
            AND fecha_venta__c >=: fechaFin6MESES
            AND sucursal_origen_clave__c LIKE: Plaza + '%'
            AND origen_documentacion__c IN: valoresConsultaMigracion
            ORDER BY fecha_venta__c
        ];
        
        system.debug('ventas6MESES.size(): ' + ventas6MESES.size());
        
        if(ventasANIOACTUAL.isEmpty() && ventas6MESES.isEmpty()) {
            valorDeRetorno = true;
        } else {
            if(!ventas6MESES.isEmpty()) {
                // Agrupar ventas por mes
                Map<Integer, Decimal> totalsPorMes = new Map<Integer, Decimal>();
                for(Ventas__dlm venta : ventas6MESES) {
                    Integer mes = venta.fecha_venta__c.month();
                    Decimal total = totalsPorMes.get(mes);
                    if(total == null) total = 0;
                    totalsPorMes.put(mes, total + venta.total_antes_de_impuestos__c);
                }
                
                // Convertir totales a mapa de valores por mes
                for(Integer mes : totalsPorMes.keySet()) {
                    valorVentaMes.put(valorMes.get(mes), totalsPorMes.get(mes));
                    System.debug('MES: ' + mes);
                    System.debug('VALOR: ' + totalsPorMes.get(mes));
                }
                
                wAsigEjecMigrado.valorVentaMes = valorVentaMes;
                wAsigEjecMigrado.ventasUltimos6Meses = true;
            } else {
                wAsigEjecMigrado.ventasUltimos6Meses = false;
            }
            valorDeRetorno = false;
        }
        
        wAsigEjecMigrado.otrosIdsConVenta = !ventasANIOACTUAL.isEmpty();
        wAsigEjecMigrado.ventasUltimos6Meses = true;
        wAsigEjecMigrado.valorDeRetorno = valorDeRetorno;
        
        System.debug('valorDeRetorno: ' + valorDeRetorno);
        
        if(wAsigEjecMigrado.valorDeRetorno == false && currentAcc.OmitirValidacionDeInformacion__c == false){
            
            String mensaje;
            
            if(wAsigEjecMigrado.valorVentaMes == null && wAsigEjecMigrado.otrosIdsConVenta== true){
                currentAcc.AsignarEjecutivoACuentaEnSipweb__c = false;
                currentAcc.AsignacionRegular_Nuevo__c = false;
                
                currentAcc.ALERTA_Revisa_su_Venta_existente__c  =  'El cliente ya cuenta con ventas mensuales en otros ids de sipweb con la misma razon social, Si está seguro de avanzar bajo el estatus solicitado, marque la casilla De acuerdo con validación de información';
                
            }else if(wAsigEjecMigrado.valorVentaMes != null && wAsigEjecMigrado.otrosIdsConVenta== true){
                currentAcc.AsignarEjecutivoACuentaEnSipweb__c = false;
                currentAcc.AsignacionRegular_Nuevo__c = false;
                
                mensaje = 'El cliente ya cuenta con las siguientes 	ventas: ';
                for(String key: wAsigEjecMigrado.valorVentaMes.keySet()){
                    mensaje+= key +' : $ '+ String.format(wAsigEjecMigrado.valorVentaMes.get(key).format(), args)+ '. ';
                }
                mensaje += 'y ventas de otros Ids con el mismo nombre de cuenta. ';
                
                currentAcc.ALERTA_Revisa_su_Venta_existente__c  = mensaje + 'Si está seguro de avanzar bajo el estatus solicitado, marque la casilla De acuerdo con validación de información';
                
            }else{
                currentAcc.AsignarEjecutivoACuentaEnSipweb__c = false;
                currentAcc.AsignacionRegular_Nuevo__c = false;
                
                mensaje = 'El cliente ya cuenta con las siguientes 	ventas: ';
                for(String key: wAsigEjecMigrado.valorVentaMes.keySet()){
                    mensaje+= key +' : $ '+ String.format( wAsigEjecMigrado.valorVentaMes.get(key).format(), args)+ '. ';
                }
                
                currentAcc.ALERTA_Revisa_su_Venta_existente__c  = mensaje + 'Si está seguro de avanzar bajo el estatus solicitado, marque la casilla De acuerdo con validación de información';
                
            }
        }
        
        if(wAsigEjecMigrado.valorDeRetorno==true){
            currentAcc.Validacion_Migracion_GERENTE_KAM__c = true;
            currentAcc.Validacion_Migracion_GERENTE_KAM_AUX__c = false;
            currentAcc.ValidacionMigracion__c = true;
        }
        else{
            currentAcc.Validacion_Migracion_GERENTE_KAM_AUX__c = true;
            currentAcc.Validacion_Migracion_GERENTE_KAM__c = false;
        }
        
        if(currentAcc.OmitirValidacionDeInformacion__c == true){
            String mensaje;
            if((wAsigEjecMigrado.valorVentaMes == null && wAsigEjecMigrado.otrosIdsConVenta== true) || test.isRunningTest()){
                mensaje = 'El cliente ya cuenta con ventas mensuales en otros ids de sipweb con la misma razon social';
            }else if(wAsigEjecMigrado.valorVentaMes != null && wAsigEjecMigrado.otrosIdsConVenta== true){
                mensaje = 'El cliente ya cuenta con las siguientes 	ventas: ';
                for(String key: wAsigEjecMigrado.valorVentaMes.keySet()){mensaje+= key +' : $ '+String.format( wAsigEjecMigrado.valorVentaMes.get(key).format(), args)  + '. ';}
                mensaje += 'y ventas de otros Ids con el mismo nombre de cuenta. ';
            }else{
                mensaje = 'El cliente ya cuenta con las siguientes 	ventas: ';
                for(String key: wAsigEjecMigrado.valorVentaMes.keySet()){mensaje+= key +' : $ '+ +String.format( wAsigEjecMigrado.valorVentaMes.get(key).format(), args)  + '. ';}
            }
            currentAcc.ValidacionMigracion__c = true;
            currentAcc.ALERTA_Revisa_su_Venta_existente__c  = '<p style="color:red;">' +mensaje+'</p>' ;
            //acc.AnalisisDeValidacion__c  = '<p style="color:red;">' +mensaje+'</p>' ;
        }
        
        update currentAcc;
        
    }

    public static void ConsultaDatosFiscales(List<Account> lstAccounts, Map<Id, Account> accOldMap, Boolean blninsert, Boolean blnUpdate){
        /*for(Account ac : lstAccounts){
            if(!ac.DatosFiscalesObtenidosDeSipWeb__c){
                Account oldAcc = new Account();
                if(blnUpdate){
                    oldAcc = accOldMap.get(ac.Id);
                }
                if(blninsert ||
                    (blnUpdate &&
                    (ac.RFC__c != oldAcc.RFC__c ||
                    ac.RazonSocial__c != oldAcc.RazonSocial__c ||
                    ac.RegimenCapital__c != oldAcc.RegimenCapital__c) ||
                    ac.Colonia_Facturaci_n__c != oldAcc.Colonia_Facturaci_n__c ||
                    ac.Zona_facturacion__c != oldAcc.Zona_facturacion__c ||
                    ac.Regimen_fiscal_CCP__c != oldAcc.Regimen_fiscal_CCP__c ||
                    ac.Uso_de_cfdi_CCP__c != oldAcc.Uso_de_cfdi_CCP__c ||
                    ac.Email_de_factura__c != oldAcc.Email_de_factura__c ||
                    ac.Numero_de_facturacion__c != oldAcc.Numero_de_facturacion__c ||
                    ac.NumeroInterior__c != oldAcc.NumeroInterior__c ||
                    ac.Tipo_direccion__c != oldAcc.Tipo_direccion__c ||
                    ac.Piso_facturacion__c != oldAcc .Piso_facturacion__c ||
                    ac.Municipio_Delegaci_n_Sector_facturacion__c != oldAcc.Municipio_Delegaci_n_Sector_facturacion__c ||
                    ac.Nombres__c != oldAcc.Nombres__c ||
                    ac.ApellidoPaterno__c != oldAcc.ApellidoPaterno__c ||
                    ac.ApellidoMaterno__c != oldAcc.ApellidoMaterno__c
                    ))
                {
                    PAQ_WSDatosFiscales.CallWS_DatosFiscales(ac.RFC__c);
                }
            }
        }*/
    }
  
    public static void ValidaDatosFiscales(List<Account> lstAccounts, Map<Id, Account> accOldMap, Boolean blninsert, Boolean blnUpdate){
        //Salvador Ramírez (sramirez@freewayconsulting.com) Método encargado de validar si los datos fiscales han cambiado y de llamar al WS que los obtendrá de acuerdo a como se encuentren en sipweb
        String M                = '';
        String strTipoRegistro  = '';
        Account oldAcc          = new Account();
        for(Account ac:lstAccounts){
            strTipoRegistro = PAQ_FuncionesGenericas.GetNombreTipoDeRegistro(ac.RecordTypeId);
            if(blnUpdate){
                oldAcc = accOldMap.get(ac.Id);
            }
            if(ac.RFC__c != 'XAXX010101000'){
                if(blninsert ||
                    (blnUpdate &&
                    (ac.RFC__c != oldAcc.RFC__c ||
                    ac.RazonSocial__c != oldAcc.RazonSocial__c ||
                    ac.RegimenCapital__c != oldAcc.RegimenCapital__c) ||
                    ac.Colonia_Facturaci_n__c != oldAcc.Colonia_Facturaci_n__c ||
                    ac.Regimen_fiscal_CCP__c != oldAcc.Regimen_fiscal_CCP__c ||
                    ac.Uso_de_cfdi_CCP__c != oldAcc.Uso_de_cfdi_CCP__c ||
                    ac.Numero_de_facturacion__c != oldAcc.Numero_de_facturacion__c ||
                    ac.NumeroInterior__c != oldAcc.NumeroInterior__c ||
                    ac.Tipo_direccion__c != oldAcc.Tipo_direccion__c ||
                    ac.Municipio_Delegaci_n_Sector_facturacion__c != oldAcc.Municipio_Delegaci_n_Sector_facturacion__c ||
                    ac.Nombres__c != oldAcc.Nombres__c ||
                    ac.ApellidoPaterno__c != oldAcc.ApellidoPaterno__c ||
                    ac.ApellidoMaterno__c != oldAcc.ApellidoMaterno__c
                    ))
                {
                    System.debug('Marca: ' + ac.Cuenta_originada_de_prospecto__c + '. Tipo de persona: ' + strTipoRegistro);
                    if(!ac.DatosFiscalesObtenidosDeSipWeb__c){
                        if(!test.isRunningTest() && !System.isBatch() && !System.isFuture() && !ac.Cuenta_originada_de_prospecto__c && !ac.Actualizado_desde_API__c){                            
                            M  = '';
                            M = PAQ_FuncionesGenericas.ValidaDatosFiscales(ac); //Función que validará si los datos fiscales cambiaron
                            if(M != ''){
                                //ac.addError(M);
                            }
                            PAQ_WSDatosFiscales.CallWS_DatosFiscales(ac.RFC__c); //Método que llamará el servicio web para obtener los datos fiscales de sipweb
                        }
                    } else {
                        if(blnUpdate && ac.DatosFiscalesObtenidosDeSipWeb__c == oldAcc.DatosFiscalesObtenidosDeSipWeb__c && ac.DatosFiscalesObtenidosDeSipWeb__c && !System.isBatch() && !System.isFuture() && !ac.Actualizado_desde_API__c){
                            //Si se está actualizando y no ha cambiado el flag de los datos fiscales obtenidos de sipweb y este se encuentra en true y no se está ejecutando un batch (PAQ_BatchActualizaDatosFiscales) o por un método futuro (PAQ_WSDatosFiscales.CallWS_DatosFiscales)
                            //ac.addError('Error actualizando datos fiscales de la cuenta. No es posible alterarlos cuando ya han sido sincronizados con SipWeb.');
                        }
                    }
                    if (ac.Cuenta_originada_de_prospecto__c) {
                        if (strTipoRegistro == 'Persona Moral') {
                            ac.RazonSocial__c = '.';
                            if (ac.RFC__c == null) {
                                ac.RFC__c = 'RFC123456PM1';
                            }
                            ac.Regimen_Fiscal_CCP__c = '603 Personas Morales con Fines no Lucrativos';
                        } else {
                            ac.Nombres__c = '.';
                            ac.ApellidoPaterno__c = '.';
                            ac.ApellidoMaterno__c = '.';
                            if (ac.RFC__c == null) {
                                ac.RFC__c = 'XAXX010101000';
                            }
                            ac.Regimen_Fiscal_CCP__c = '616 Sin obligaciones fiscales';
                        }
                        ac.Uso_de_cfdi_CCP__c = 'S01 Sin efectos fiscales.';
                        ac.BillingPostalCode = '00000';
                        ac.Cuenta_originada_de_prospecto__c = false;
                    }
                    if (ac.Actualizado_desde_API__c) {
                        ac.Actualizado_desde_API__c = false;
                    }
                }
            }
        }
    }
   
    @future(callout= true)
    public static void getVentaPromedioMensual (String razonSocial, String RFC, String IdSipweb,String Plaza, String AccountId){

        Account currentAcc = [SELECT Id,PromedioMensualVentas__c FROM Account WHERE Id =:AccountId LIMIT 1];
        Decimal sumaVenta 				= 0;
        Decimal promedioMensualVenta 	= 0;

        Integer numberDays = date.daysInMonth(Date.today().Year(), Date.today().Month()-1);
        Date fechaFin = Date.newInstance(Date.today().Year(), Date.today().Month()-1, numberDays);
        system.debug('END_DATE: ' +  fechaFin);

        Date fechaInicio = Date.newInstance(Date.today().Year(), Date.today().Month()-6, 1);
        system.debug('START_DATE: ' +  fechaInicio);

        Boolean valorDeRetorno;

        System.debug('IdSipweb: ' 		+ IdSipweb);
        System.debug('razonSocial: ' 	+ razonSocial);
        System.debug('RFC: ' 			+ RFC);
        System.debug('fechaInicio: ' 	+ fechaInicio);
        System.debug('fechaFin: ' 		+ fechaFin);
		
        List<Ventas__dlm> ventasList = [
            SELECT Id, fecha_venta__c, cliente_origen_clave__c, total_antes_de_impuestos__c,
            fecha_id__c, KQ_cliente_origen_clave__c, sucursal_origen_clave__c
            FROM Ventas__dlm
            WHERE cliente_origen_clave__c =: IdSipweb
            AND fecha_venta__c >=: fechaInicio
            AND fecha_venta__c <=: fechaFin
            AND sucursal_origen_clave__c LIKE: Plaza + '%'
            ORDER BY fecha_venta__c ASC
        ];

        system.debug('ventasList.size(): ' + ventasList.size());

        if(ventasList.size()==0){

            valorDeRetorno = true;

        }else{

            Date fechaPrimeraVenta = ventasList[0].fecha_venta__c;
            Integer mesesAPromediar = fechaPrimeraVenta.monthsBetween(fechaFin);

            system.debug('fechePrimeraVenta: ' +  fechaPrimeraVenta);
            system.debug('fechaFin: ' +  fechaFin);
            system.debug('fechaInicio: ' +  fechaInicio);
            system.debug('mesesAPromediar: ' +  mesesAPromediar);

            if(mesesAPromediar == 0){
                mesesAPromediar = 1;
                System.debug('Nuevo Valor de meses = 1');
            } else {
                System.debug('El valor de meses se queda igual = ' + mesesAPromediar);
            }

            for(Ventas__dlm v: ventasList){sumaVenta += v.total_antes_de_impuestos__c;
            }

            System.debug('sumaVenta: ' + sumaVenta);

            promedioMensualVenta = sumaVenta / mesesAPromediar;
            System.debug('promedioMensualVenta: ' + promedioMensualVenta);
        }

        
        currentAcc.PromedioMensualVentas__c = promedioMensualVenta;
        update currentAcc;
    }

    public static Boolean getValidacionTareas (Id accId, Id usuarioAAsignar, Datetime fechaCreacion){

        Boolean validaActividad = false;

        System.debug('fechaCreacion: ' + fechaCreacion);
        System.debug('usuarioAAsignar: ' + usuarioAAsignar);
        System.debug('accId: ' + accId);

        Account papaId = [SELECT Id, ParentId FROM Account WHERE Id=:accId];
        System.debug('ParentId: ' + papaId.ParentId);

        List<Opportunity> oppo = new List<Opportunity>();
        List<String> OppsIds = new List<String>();

        if(papaId.ParentId != null) {
        	oppo = [SELECT Id, AccountId, OwnerId FROM Opportunity
                WHERE (AccountId=:accId OR AccountId=:papaId.ParentId)
                AND OwnerId=:usuarioAAsignar];
        } else {
        oppo = [SELECT Id, AccountId, OwnerId FROM Opportunity
                WHERE AccountId=:accId
                AND OwnerId=:usuarioAAsignar];
        }

        System.debug('opportunities: ' + oppo.size());

        if(oppo.size() > 0) {
            for(Opportunity o : oppo){
                OppsIds.add(o.Id);
            }
        }

        System.debug('OppsIds.size(): ' + OppsIds.size());

        List<Task> tareasGeneradas = new List<Task>();
        List<Event> EventosGenerados = new List<Event>();

        if(OppsIds.size() > 0){
            if(papaId.ParentId != null){
            	system.debug('ParentId != null');
        		tareasGeneradas = [SELECT Id, OwnerId, CreatedDate, WhatId
                                      	  FROM Task
                                      	  WHERE (WhatId =: papaId.ParentId OR WhatId =: accId OR WhatId IN: OppsIds)
                                      	  AND OwnerId =: usuarioAAsignar];

            	EventosGenerados = [SELECT Id, OwnerId, CreatedDate, WhatId
                                        	FROM EVENT
                                        	WHERE (WhatId =: papaId.ParentId OR WhatId =: accId OR WhatId IN: OppsIds)
                                        	AND OwnerId =: usuarioAAsignar];
        	} else {
        		system.debug('ParentId == null');
        		tareasGeneradas = [SELECT Id, OwnerId, CreatedDate, WhatId
                                      FROM Task
                                      WHERE (WhatId =: accId OR WhatId IN: OppsIds)
                                      AND OwnerId =: usuarioAAsignar];

        		EventosGenerados = [SELECT Id, OwnerId, CreatedDate, WhatId
                                        FROM EVENT
                                        WHERE (WhatId =: accId OR WhatId IN: OppsIds)
                                        AND OwnerId =: usuarioAAsignar];
        	}

        } else {
        	if(papaId.ParentId != null){
            	system.debug('ParentId != null');
        		tareasGeneradas = [SELECT Id, OwnerId, CreatedDate, WhatId
                                      	  FROM Task
                                      	  WHERE (WhatId =: papaId.ParentId OR WhatId =: accId)
                                      	  AND OwnerId =: usuarioAAsignar];

            	EventosGenerados = [SELECT Id, OwnerId, CreatedDate, WhatId
                                        	FROM EVENT
                                        	WHERE (WhatId =: papaId.ParentId OR WhatId =: accId)
                                        	AND OwnerId =: usuarioAAsignar];
        	} else {
        		system.debug('ParentId == null');
        		tareasGeneradas = [SELECT Id, OwnerId, CreatedDate, WhatId
                                      FROM Task
                                      WHERE WhatId =: accId
                                      AND OwnerId =: usuarioAAsignar];

        		EventosGenerados = [SELECT Id, OwnerId, CreatedDate, WhatId
                                        FROM EVENT
                                        WHERE WhatId =: accId
                                        AND OwnerId =: usuarioAAsignar];
        	}
        }

        System.debug('tareasGeneradas.size(): ' + tareasGeneradas.size());
        System.debug('EventosGenerados.size(): ' + EventosGenerados.size());

        if((tareasGeneradas.size()>0 || EventosGenerados.size()>0)){
            validaActividad = true;
        }

        return validaActividad;
    }
    
    public static Boolean getValidacionCotizaciones (Id accId, Id usuarioAAsignar){

        Boolean validaCotizaciones = false;

        System.debug('usuarioAAsignar: ' + usuarioAAsignar);
        System.debug('accId: ' + accId);

        Account papaId = [SELECT Id, ParentId FROM Account WHERE Id=:accId];
        System.debug('ParentId: ' + papaId.ParentId);

        List<SBQQ__Quote__c> cotizacionesGeneradas = new List<SBQQ__Quote__c>();

        if(papaId.ParentId != null){
        	system.debug('ParentId != null');
        	cotizacionesGeneradas = [SELECT Id, OwnerId, SBQQ__Account__c FROM SBQQ__Quote__c WHERE SBQQ__Account__c=:papaId.ParentId OR SBQQ__Account__c=:accId];
        } else {
            system.debug('ParentId == null');
            cotizacionesGeneradas = [SELECT Id, OwnerId, SBQQ__Account__c FROM SBQQ__Quote__c WHERE SBQQ__Account__c=:accId];
        }

        System.debug('cotizacionesGeneradas.size(): ' + cotizacionesGeneradas.size());

        if(cotizacionesGeneradas.size()>0){
            validaCotizaciones = true;
        }

        return validaCotizaciones;
    }
    public static void pre_asignaEjecutivo (Id accId, Id usuarioAAsignar){

    }
    class wrapperAsignacionEjecutivoRecuperado{
    	public Map<String, Decimal> valorVentaMes;
        public Boolean valorDeRetorno;
        public Boolean otrosIdsConVenta;
        public Boolean ventasUltimos6Meses;
    }
    class wrapperAsignacionEjecutivoNuevo{
    	public Boolean valorDeRetorno;
        public Decimal promedioVentasMensual;
        public Decimal crecimiento;
    }
    public class ConsultaRFC{
        public header header;
        public body body;
    }
    public class header{
        public Security security;
    }
    public class Security{
        public String user;
        public String password;
        public Integer type;
        public String token;
    }
    public class body{
        public request request;
        public response response;
    }
    public class request {
        public data data;
    }
    public class data{
        public String rfc;
    }
    public class response{
        public Boolean success;
        public List<messages> messages;
        public dataresponse data;
        public String objectDTO;
    }
    public class dataresponse{
        public String rfcGenerico;
    }
    public class messages{
        public String code;
        public String description;
        public String typeError;
    }
}