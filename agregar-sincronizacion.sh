#!/bin/bash

ARCHIVO="index.html"
BACKUP="$ARCHIVO.bak"

# 1. Hacer backup
cp "$ARCHIVO" "$BACKUP"
echo "✅ Backup creado: $BACKUP"

# 2. Buscar donde termina el panel de administración
LINEA_FIN=$(grep -n "Cerrar Panel" "$ARCHIVO" | tail -1 | cut -d: -f1)

if [ -z "$LINEA_FIN" ]; then
    echo "❌ No encontré 'Cerrar Panel' en el archivo"
    exit 1
fi

echo "📌 Panel encontrado terminando en línea: $LINEA_FIN"

# 3. Insertar nueva sección de sincronización
sed -i "${LINEA_FIN}a\\
<!-- ========================================= -->\\
<!-- 🚀 SECCIÓN DE SINCRONIZACIÓN CON INTERNET -->\\
<!-- ========================================= -->\\
<div id=\"seccion-sincronizacion\" style=\"margin-top: 30px; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 15px; color: white; box-shadow: 0 10px 30px rgba(0,0,0,0.3);\">\\
    <h2 style=\"text-align: center; margin-bottom: 20px;\">🌐 PUBLICACIÓN EN INTERNET</h2>\\
    \\
    <div style=\"background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px;\">\\
        <h3>📤 Exportar Datos para Internet</h3>\\
        <p>Exporta todas las propiedades para publicarlas automáticamente en tu sitio web.</p>\\
        \\
        <div style=\"display: flex; gap: 15px; margin-top: 20px;\">\\
            <button onclick=\"exportarDatosParaInternet()\" style=\"flex: 1; padding: 15px; background: #10b981; color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: bold; cursor: pointer; transition: all 0.3s;\">\\
                💾 DESCARGAR DATOS ACTUALIZADOS\\
                <div style=\"font-size: 12px; opacity: 0.9;\">Generar datos-inmobiliaria.json</div>\\
            </button>\\
            \\
            <button onclick=\"mostrarQR()\" style=\"flex: 1; padding: 15px; background: #3b82f6; color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: bold; cursor: pointer; transition: all 0.3s;\">\\
                📱 MOSTRAR CÓDIGO QR\\
                <div style=\"font-size: 12px; opacity: 0.9;\">Para escanear desde el celular</div>\\
            </button>\\
        </div>\\
        \\
        <div id=\"qr-container\" style=\"display: none; text-align: center; margin-top: 20px;\">\\
            <div id=\"qrcode\"></div>\\
            <p style=\"font-size: 12px; margin-top: 10px;\">Escanea este código desde tu celular para abrir la página</p>\\
        </div>\\
        \\
        <div id=\"mensaje-exportacion\" style=\"margin-top: 20px; padding: 10px; border-radius: 5px; display: none;\"></div>\\
    </div>\\
</div>" "$ARCHIVO"

echo "✅ Sistema de sincronización agregado exitosamente!"
echo ""
echo "📋 RESUMEN:"
echo "   - Backup: index.html.bak"
echo "   - Se agregó sección de publicación después del panel admin"
echo "   - Botones: 'DESCARGAR DATOS' y 'MOSTRAR CÓDIGO QR'"
echo ""
echo "🔄 Ahora agregaremos las funciones JavaScript necesarias..."
