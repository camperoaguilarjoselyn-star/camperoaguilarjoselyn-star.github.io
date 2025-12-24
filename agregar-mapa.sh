#!/bin/bash

ARCHIVO="index.html"

# Buscar donde agregar la sección del mapa
LINEA_PROP=$(grep -n "propiedades-container" "$ARCHIVO" | head -1 | cut -d: -f1)

sed -i "${LINEA_PROP}i\\
<!-- ========================================= -->\\
<!-- 🗺️ MAPA INTERACTIVO DE PROPIEDADES       -->\\
<!-- ========================================= -->\\
<div id=\"mapa-container\" style=\"margin: 30px 0; display: none;\">\\
    <h3 style=\"text-align: center; margin-bottom: 20px;\"><i class=\"fas fa-map-marked-alt\"></i> MAPA DE PROPIEDADES</h3>\\
    <div style=\"background: white; padding: 20px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.1);\">\\
        <div id=\"mapa\" style=\"height: 400px; border-radius: 10px; overflow: hidden; background: #f8f9fa; display: flex; align-items: center; justify-content: center;\">\\
            <div style=\"text-align: center; padding: 40px;\">\\
                <i class=\"fas fa-map\" style=\"font-size: 64px; color: #667eea; margin-bottom: 20px;\"></i>\\
                <h4>Mapa interactivo</h4>\\
                <p>Aquí se mostrarán las ubicaciones de tus propiedades</p>\\
                <button onclick=\"cargarMapa()\" style=\"background: #667eea; color: white; border: none; padding: 10px 20px; border-radius: 25px; margin-top: 15px; cursor: pointer;\">\\
                    <i class=\"fas fa-sync-alt\"></i> Cargar Mapa\\
                </button>\\
            </div>\\
        </div>\\
        \\
        <div style=\"margin-top: 20px; display: flex; justify-content: center; gap: 15px;\">\\
            <button onclick=\"mostrarMapa()\" style=\"background: #10b981; color: white; border: none; padding: 10px 25px; border-radius: 8px; cursor: pointer;\">\\
                <i class=\"fas fa-eye\"></i> Mostrar Mapa\\
            </button>\\
            <button onclick=\"ocultarMapa()\" style=\"background: #ef4444; color: white; border: none; padding: 10px 25px; border-radius: 8px; cursor: pointer;\">\\
                <i class=\"fas fa-eye-slash\"></i> Ocultar Mapa\\
            </button>\\
        </div>\\
    </div>\\
</div>\\
\\
<script>\\
// Coordenadas de Cochabamba\\
const coordenadasCbba = {\\
    centro: [-17.3895, -66.1568],\\
    zonas: {\\
        'Cercado': [-17.3895, -66.1568],\\
        'Quillacollo': [-17.3974, -66.2819],\\
        'Sacaba': [-17.4041, -66.0402],\\
        'Colcapirhua': [-17.3907, -66.2374],\\
        'Tiquipaya': [-17.3388, -66.2153],\\
        'Vinto': [-17.3941, -66.3167]\\
    }\\
};\\
\\
function mostrarMapa() {\\
    document.getElementById('mapa-container').style.display = 'block';\\
    cargarMapa();\\
}\\
\\
function ocultarMapa() {\\
    document.getElementById('mapa-container').style.display = 'none';\\
}\\
\\
function cargarMapa() {\\
    const mapaDiv = document.getElementById('mapa');\\
    mapaDiv.innerHTML = \`\\
        <div style=\"text-align: center; padding: 30px;\">\\
            <div class=\"spinner\" style=\"margin: 0 auto 20px;\"></div>\\
            <h4>Cargando mapa interactivo...</h4>\\
            <p>Mostrando propiedades en Cochabamba</p>\\
        </div>\\
    \`;\\
    \\
    // Simular carga del mapa\\
    setTimeout(() => {\\
        // Obtener propiedades\\
        const propiedades = [];\\
        for (let i = 0; i < localStorage.length; i++) {\\
            const key = localStorage.key(i);\\
            if (key.startsWith('propiedad_')) {\\
                try {\\
                    const propiedad = JSON.parse(localStorage.getItem(key));\\
                    propiedades.push(propiedad);\\
                } catch (e) {}\\
            }\\
        }\\
        \\
        // Crear mapa simple (sin API key)\\
        let mapaHTML = \`<div style=\"width: 100%; height: 400px; position: relative; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 10px; overflow: hidden;\">\\
            <div style=\"position: absolute; top: 20px; left: 20px; background: white; padding: 15px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.2);\">\\
                <h5 style=\"margin: 0 0 10px 0; color: #333;\"><i class=\"fas fa-map-pin\"></i> Cochabamba</h5>\`;\\
        \\
        // Agregar marcadores\\
        propiedades.forEach((prop, index) => {\\
            const zonaCoords = coordenadasCbba.zonas[prop.zona] || coordenadasCbba.centro;\\
            const left = 50 + (Math.random() * 30 - 15);\\
            const top = 50 + (Math.random() * 30 - 15);\\
            \\
            mapaHTML += \`<div style=\"position: absolute; left: \${left}%; top: \${top}%; transform: translate(-50%, -50%);\">\\
                <div style=\"background: \${prop.operacion === 'Venta' ? '#ef4444' : '#3b82f6'}; color: white; width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: bold; box-shadow: 0 3px 10px rgba(0,0,0,0.3); cursor: pointer;\" title=\"\${prop.tipo} - \${prop.zona}\">\\
                    \${index + 1}\\
                </div>\\
            </div>\`;\\
        });\\
        \\
        mapaHTML += \`</div>\\
            <div style=\"position: absolute; bottom: 20px; right: 20px; background: rgba(255,255,255,0.9); padding: 10px 15px; border-radius: 8px; font-size: 12px;\">\\
                <div><span style=\"display: inline-block; width: 12px; height: 12px; background: #ef4444; border-radius: 50%; margin-right: 5px;\"></span> En Venta</div>\\
                <div><span style=\"display: inline-block; width: 12px; height: 12px; background: #3b82f6; border-radius: 50%; margin-right: 5px;\"></span> En Alquiler</div>\\
            </div>\\
            <div style=\"position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 48px; color: rgba(255,255,255,0.1);\">\\
                <i class=\"fas fa-map\"></i>\\
            </div>\\
        </div>\`;\\
        \\
        mapaDiv.innerHTML = mapaHTML;\\
        \\
        // Mostrar información\\
        const infoDiv = document.createElement('div');\\
        infoDiv.style.cssText = 'position: absolute; bottom: 70px; left: 20px; right: 20px; background: rgba(255,255,255,0.95); padding: 15px; border-radius: 10px; font-size: 14px; box-shadow: 0 5px 15px rgba(0,0,0,0.2);';\\
        infoDiv.innerHTML = \`<strong>\${propiedades.length} propiedades</strong> en el mapa • <span style=\"color: #ef4444;\">\${propiedades.filter(p => p.operacion === 'Venta').length} en venta</span> • <span style=\"color: #3b82f6;\">\${propiedades.filter(p => p.operacion === 'Alquiler').length} en alquiler</span>\`;\\
        mapaDiv.querySelector('div').appendChild(infoDiv);\\
        \\
    }, 1500);\\
}\\
</script>" "$ARCHIVO"

echo "✅ Mapa interactivo agregado!"
