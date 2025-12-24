// sincronizar.js - Sistema de sincronización para Inmobiliaria CAMPERO

class Sincronizador {
    constructor() {
        this.dataURL = 'data.json';
        this.localStorageKey = 'inmobiliariaProps';
        this.syncInterval = 30000; // 30 segundos
        this.isSyncing = false;
    }

    // Cargar datos desde JSON remoto
    async cargarRemoto() {
        try {
            console.log('📥 Cargando datos remotos...');
            const response = await fetch(`${this.dataURL}?t=${Date.now()}`);
            
            if (!response.ok) {
                throw new Error(`Error HTTP: ${response.status}`);
            }
            
            const datos = await response.json();
            console.log('✅ Datos remotos cargados:', datos.propiedades?.length || 0, 'propiedades');
            
            // Guardar en localStorage para respaldo
            localStorage.setItem('datosRemotos', JSON.stringify(datos));
            localStorage.setItem('ultimaSincronizacion', new Date().toISOString());
            
            return datos;
            
        } catch (error) {
            console.error('❌ Error cargando datos remotos:', error);
            return this.cargarLocal(); // Usar datos locales como respaldo
        }
    }

    // Cargar datos desde localStorage
    cargarLocal() {
        try {
            const datosGuardados = localStorage.getItem('datosRemotos');
            if (datosGuardados) {
                return JSON.parse(datosGuardados);
            }
            
            // Si no hay datos remotos, usar los datos de la aplicación
            const propiedades = [];
            for (let i = 0; i < localStorage.length; i++) {
                const key = localStorage.key(i);
                if (key.startsWith('propiedad_')) {
                    try {
                        const prop = JSON.parse(localStorage.getItem(key));
                        propiedades.push(prop);
                    } catch (e) {
                        console.error('Error parseando propiedad:', key, e);
                    }
                }
            }
            
            return {
                propiedades: propiedades,
                zonas: JSON.parse(localStorage.getItem('inmobiliariaZonas') || '[]'),
                estadisticas: this.calcularEstadisticas(propiedades),
                ultima_actualizacion: localStorage.getItem('ultimaSincronizacion') || new Date().toISOString()
            };
            
        } catch (error) {
            console.error('❌ Error cargando datos locales:', error);
            return { propiedades: [], zonas: [], estadisticas: {}, ultima_actualizacion: '' };
        }
    }

    // Calcular estadísticas
    calcularEstadisticas(propiedades) {
        return {
            total: propiedades.length,
            venta: propiedades.filter(p => p.t === 'venta').length,
            alquiler: propiedades.filter(p => p.t === 'alquiler').length,
            anticretico: propiedades.filter(p => p.t === 'anticretico').length,
            lote: propiedades.filter(p => p.t === 'lote').length
        };
    }

    // Sincronizar datos locales con remotos
    async sincronizar() {
        if (this.isSyncing) return;
        
        this.isSyncing = true;
        console.log('🔄 Sincronizando...');
        
        try {
            // Cargar datos remotos
            const datosRemotos = await this.cargarRemoto();
            
            // Aquí puedes agregar lógica para mezclar datos locales y remotos
            // Por ahora, simplemente devolvemos los datos remotos
            
            this.isSyncing = false;
            return datosRemotos;
            
        } catch (error) {
            console.error('❌ Error en sincronización:', error);
            this.isSyncing = false;
            return this.cargarLocal();
        }
    }

    // Iniciar sincronización automática
    iniciarSincronizacionAutomatica() {
        console.log('⏰ Sincronización automática iniciada');
        
        // Sincronizar inmediatamente
        this.sincronizar();
        
        // Programar sincronizaciones periódicas
        setInterval(() => {
            this.sincronizar();
        }, this.syncInterval);
    }

    // Exportar datos para GitHub
    exportarParaGitHub() {
        try {
            const datos = this.cargarLocal();
            const jsonStr = JSON.stringify(datos, null, 2);
            
            // Crear archivo para descargar
            const blob = new Blob([jsonStr], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            
            a.href = url;
            a.download = `inmobiliaria-datos-${new Date().toISOString().split('T')[0]}.json`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            
            // Limpiar URL
            setTimeout(() => URL.revokeObjectURL(url), 100);
            
            console.log('✅ Datos exportados:', datos.propiedades.length, 'propiedades');
            
            return {
                success: true,
                message: 'Datos exportados correctamente',
                count: datos.propiedades.length,
                filename: a.download
            };
            
        } catch (error) {
            console.error('❌ Error exportando datos:', error);
            return {
                success: false,
                message: 'Error al exportar: ' + error.message
            };
        }
    }

    // Verificar estado del sistema
    verificarEstado() {
        return {
            online: navigator.onLine,
            ultimaSincronizacion: localStorage.getItem('ultimaSincronizacion') || 'Nunca',
            propiedadesLocales: this.contarPropiedadesLocales(),
            datosRemotos: localStorage.getItem('datosRemotos') ? 'Disponibles' : 'No disponibles',
            timestamp: new Date().toISOString()
        };
    }

    contarPropiedadesLocales() {
        let count = 0;
        for (let i = 0; i < localStorage.length; i++) {
            if (localStorage.key(i).startsWith('propiedad_')) {
                count++;
            }
        }
        return count;
    }
}

// Hacer disponible globalmente
window.SincronizadorInmobiliaria = Sincronizador;

console.log('✅ Sincronizador cargado');
