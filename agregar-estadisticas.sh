#!/bin/bash

ARCHIVO="index.html"

# Buscar donde agregar el panel de estadísticas (después del título principal)
LINEA_TITULO=$(grep -n "Inmobiliaria" index.html | head -1 | cut -d: -f1)

if [ -z "$LINEA_TITULO" ]; then
    echo "❌ No encontré el título principal"
    exit 1
fi

echo "📌 Agregando panel de estadísticas después de línea: $LINEA_TITULO"

# Insertar panel de estadísticas
sed -i "$((LINEA_TITULO+1))i\\
<div id='panel-estadisticas' style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 15px; margin: 20px 0; box-shadow: 0 10px 30px rgba(0,0,0,0.2);'>\\
    <h3 style='text-align: center; margin-bottom: 20px;'><i class='fas fa-chart-line'></i> ESTADÍSTICAS EN TIEMPO REAL</h3>\\
    \\
    <div style='display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;'>\\
        <div style='background: rgba(255,255,255,0.1); padding: 15px; border-radius: 10px; text-align: center; backdrop-filter: blur(10px);'>\\
            <div id='total-propiedades' style='font-size: 32px; font-weight: bold;'>0</div>\\
            <div style='font-size: 14px; opacity: 0.9;'>PROPIEDADES</div>\\
        </div>\\
        \\
        <div style='background: rgba(255,255,255,0.1); padding: 15px; border-radius: 10px; text-align: center; backdrop-filter: blur(10px);'>\\
            <div id='propiedades-venta' style='font-size: 32px; font-weight: bold;'>0</div>\\
            <div style='font-size: 14px; opacity: 0.9;'>EN VENTA</div>\\
        </div>\\
        \\
        <div style='background: rgba(255,255,255,0.1); padding: 15px; border-radius: 10px; text-align: center; backdrop-filter: blur(10px);'>\\
            <div id='propiedades-alquiler' style='font-size: 32px; font-weight: bold;'>0</div>\\
            <div style='font-size: 14px; opacity: 0.9;'>EN ALQUILER</div>\\
        </div>\\
        \\
        <div style='background: rgba(255,255,255,0.1); padding: 15px; border-radius: 10px; text-align: center; backdrop-filter: blur(10px);'>\\
            <div id='ultima-actualizacion' style='font-size: 20px; font-weight: bold;'>--:--</div>\\
            <div style='font-size: 14px; opacity: 0.9;'>ÚLTIMA ACTUALIZACIÓN</div>\\
        </div>\\
    </div>\\
    \\
    <div style='text-align: center; margin-top: 15px;'>\\
        <button onclick='actualizarEstadisticas()' style='background: rgba(255,255,255,0.2); border: 1px solid white; color: white; padding: 8px 20px; border-radius: 25px; cursor: pointer; font-size: 14px; transition: all 0.3s;'>\\
            <i class='fas fa-sync-alt'></i> ACTUALIZAR ESTADÍSTICAS\\
        </button>\\
    </div>\\
</div>\\
\\
<script>\\
// Función para actualizar estadísticas\\
function actualizarEstadisticas() {\\
    try {\\
        // Obtener todas las propiedades\\
        const propiedades = [];\\
        for (let i = 0; i < localStorage.length; i++) {\\
            const key = localStorage.key(i);\\
            if (key.startsWith('propiedad_')) {\\
                try {\\
                    const propiedad = JSON.parse(localStorage.getItem(key));\\
                    propiedades.push(propiedad);\\
                } catch (e) {\\
                    console.error('Error:', e);\\
                }\\
            }\\
        }\\
        \\
        // Calcular estadísticas\\
        const total = propiedades.length;\\
        const enVenta = propiedades.filter(p => p.operacion === 'Venta' || p.operacion === 'venta').length;\\
        const enAlquiler = propiedades.filter(p => p.operacion === 'Alquiler' || p.operacion === 'alquiler').length;\\
        \\
        // Actualizar la interfaz\\
        document.getElementById('total-propiedades').textContent = total;\\
        document.getElementById('propiedades-venta').textContent = enVenta;\\
        document.getElementById('propiedades-alquiler').textContent = enAlquiler;\\
        document.getElementById('ultima-actualizacion').textContent = new Date().toLocaleTimeString();\\
        \\
        // Efecto visual de actualización\\
        const panel = document.getElementById('panel-estadisticas');\\
        panel.style.animation = 'none';\\
        setTimeout(() => {\\
            panel.style.animation = 'pulse 0.5s ease';\\
        }, 10);\\
        \\
    } catch (error) {\\
        console.error('Error al actualizar estadísticas:', error);\\
    }\\
}\\
\\
// Actualizar estadísticas al cargar la página\\
document.addEventListener('DOMContentLoaded', function() {\\
    setTimeout(actualizarEstadisticas, 1000);\\
    \\
    // Actualizar cada 30 segundos\\
    setInterval(actualizarEstadisticas, 30000);\\
});\\
</script>" "$ARCHIVO"

echo "✅ Panel de estadísticas agregado exitosamente!"
echo "📊 Ahora verás estadísticas en tiempo real de tus propiedades"
