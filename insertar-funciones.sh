#!/bin/bash

ARCHIVO="index.html"

# Buscar la última línea con </script>
LINEA_SCRIPT=$(grep -n "</script>" "$ARCHIVO" | tail -1 | cut -d: -f1)

if [ -z "$LINEA_SCRIPT" ]; then
    echo "❌ No encontré etiqueta </script> en el archivo"
    exit 1
fi

echo "📌 Insertando funciones en línea: $LINEA_SCRIPT"

# Insertar las funciones justo antes del </script>
sed -i "${LINEA_SCRIPT}i\\
// =============================================\\
// 🚀 FUNCIONES DE SINCRONIZACIÓN CON INTERNET\\
// =============================================\\
\\
// Función para obtener todas las propiedades\\
function obtenerTodasLasPropiedades() {\\
    const propiedades = [];\\
    \\
    // Buscar todas las propiedades en localStorage\\
    for (let i = 0; i < localStorage.length; i++) {\\
        const key = localStorage.key(i);\\
        if (key.startsWith('propiedad_')) {\\
            try {\\
                const propiedad = JSON.parse(localStorage.getItem(key));\\
                propiedades.push(propiedad);\\
            } catch (e) {\\
                console.error('Error al parsear propiedad:', key, e);\\
            }\\
        }\\
    }\\
    \\
    return propiedades;\\
}\\
\\
// Función principal para exportar datos\\
function exportarDatosParaInternet() {\\
    try {\\
        // Obtener todos los datos de la aplicación\\
        const datosCompletos = {\\
            propiedades: obtenerTodasLasPropiedades(),\\
            zonas: JSON.parse(localStorage.getItem('zonas') || '[]'),\\
            ultimaActualizacion: new Date().toISOString(),\\
            configuracion: {\\
                ajustePrecios: localStorage.getItem('ajustePrecios') || '0',\\
                moneda: localStorage.getItem('moneda') || 'Bs'\\
            }\\
        };\\
\\
        // Convertir a JSON\\
        const jsonDatos = JSON.stringify(datosCompletos, null, 2);\\
        \\
        // Crear archivo para descargar\\
        const blob = new Blob([jsonDatos], { type: 'application/json' });\\
        const url = URL.createObjectURL(blob);\\
        \\
        // Crear enlace de descarga\\
        const a = document.createElement('a');\\
        a.href = url;\\
        a.download = 'datos-inmobiliaria.json';\\
        document.body.appendChild(a);\\
        a.click();\\
        document.body.removeChild(a);\\
        URL.revokeObjectURL(url);\\
        \\
        // Mostrar mensaje de éxito\\
        mostrarMensaje('✅ Datos exportados exitosamente!', 'success');\\
        \\
        // Mostrar estadísticas\\
        console.log('📊 Estadísticas de exportación:');\\
        console.log('- Propiedades:', datosCompletos.propiedades.length);\\
        console.log('- Zonas:', datosCompletos.zonas.length);\\
        console.log('- Última actualización:', datosCompletos.ultimaActualizacion);\\
        \\
    } catch (error) {\\
        console.error('❌ Error al exportar datos:', error);\\
        mostrarMensaje('❌ Error al exportar datos: ' + error.message, 'error');\\
    }\\
}\\
\\
// Función para mostrar código QR\\
function mostrarQR() {\\
    const container = document.getElementById('qr-container');\\
    const qrDiv = document.getElementById('qrcode');\\
    \\
    if (container.style.display === 'none') {\\
        // Limpiar contenido anterior\\
        qrDiv.innerHTML = '';\\
        \\
        // URL actual de la página\\
        const url = window.location.href;\\
        \\
        // Crear QR\\
        new QRCode(qrDiv, {\\
            text: url,\\
            width: 200,\\
            height: 200,\\
            colorDark: \"#000000\",\\
            colorLight: \"#ffffff\",\\
            correctLevel: QRCode.CorrectLevel.H\\
        });\\
        \\
        container.style.display = 'block';\\
    } else {\\
        container.style.display = 'none';\\
    }\\
}\\
\\
// Función para mostrar mensajes\\
function mostrarMensaje(texto, tipo) {\\
    const div = document.getElementById('mensaje-exportacion');\\
    div.textContent = texto;\\
    div.style.display = 'block';\\
    div.style.padding = '15px';\\
    div.style.borderRadius = '8px';\\
    div.style.marginTop = '15px';\\
    \\
    if (tipo === 'success') {\\
        div.style.background = 'rgba(16, 185, 129, 0.2)';\\
        div.style.border = '1px solid #10b981';\\
        div.style.color = '#10b981';\\
    } else {\\
        div.style.background = 'rgba(239, 68, 68, 0.2)';\\
        div.style.border = '1px solid #ef4444';\\
        div.style.color = '#ef4444';\\
    }\\
    \\
    // Ocultar mensaje después de 5 segundos\\
    setTimeout(() => {\\
        div.style.display = 'none';\\
    }, 5000);\\
}\\
\\
// Cargar librería QRCode si no está disponible\\
if (typeof QRCode === 'undefined') {\\
    const script = document.createElement('script');\\
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js';\\
    script.onload = function() {\\
        console.log('✅ QRCode library loaded');\\
    };\\
    document.head.appendChild(script);\\
}" "$ARCHIVO"

echo "✅ Funciones JavaScript agregadas exitosamente!"
