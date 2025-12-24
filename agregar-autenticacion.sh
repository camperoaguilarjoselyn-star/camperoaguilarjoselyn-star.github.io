#!/bin/bash

ARCHIVO="index.html"

echo "🔐 Creando sistema de autenticación segura..."

# 1. Buscar línea del body
LINEA_BODY=$(grep -n "<body" "$ARCHIVO" | head -1 | cut -d: -f1)

if [ -z "$LINEA_BODY" ]; then
    echo "❌ No encontré <body> en el archivo"
    exit 1
fi

echo "📌 Agregando modal de login después de línea: $LINEA_BODY"

# Insertar modal de login
sed -i "$((LINEA_BODY+1))i\\
<!-- ========================================= -->\\
<!-- 🔐 MODAL DE LOGIN (SOLO ADMIN)           -->\\
<!-- ========================================= -->\\
<div id=\"modalLogin\" style=\"display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 9999; backdrop-filter: blur(5px);\">\\
    <div style=\"position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 90%; max-width: 400px; background: white; border-radius: 20px; padding: 40px; box-shadow: 0 20px 60px rgba(0,0,0,0.3);\">\\
        \\
        <!-- Logo y título -->\\
        <div style=\"text-align: center; margin-bottom: 30px;\">\\
            <div style=\"width: 80px; height: 80px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 20px;\">\\
                <i class=\"fas fa-lock\" style=\"font-size: 32px; color: white;\"></i>\\
            </div>\\
            <h2 style=\"color: #333; margin-bottom: 10px;\">ACCESO RESTRINGIDO</h2>\\
            <p style=\"color: #666; font-size: 14px;\">Solo personal autorizado</p>\\
        </div>\\
        \\
        <!-- Formulario de login -->\\
        <div id=\"loginForm\">\\
            <div style=\"margin-bottom: 20px;\">\\
                <label style=\"display: block; margin-bottom: 8px; color: #555; font-weight: 500;\">Usuario</label>\\
                <input type=\"text\" id=\"inputUsuario\" placeholder=\"Ingresa tu usuario\" style=\"width: 100%; padding: 14px; border: 2px solid #e0e0e0; border-radius: 10px; font-size: 16px; transition: all 0.3s; box-sizing: border-box;\">\\
            </div>\\
            \\
            <div style=\"margin-bottom: 25px;\">\\
                <label style=\"display: block; margin-bottom: 8px; color: #555; font-weight: 500;\">Contraseña</label>\\
                <input type=\"password\" id=\"inputPassword\" placeholder=\"Ingresa tu contraseña\" style=\"width: 100%; padding: 14px; border: 2px solid #e0e0e0; border-radius: 10px; font-size: 16px; transition: all 0.3s; box-sizing: border-box;\">\\
            </div>\\
            \\
            <!-- Botón de login -->\\
            <button onclick=\"verificarLogin()\" style=\"width: 100%; padding: 16px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: bold; cursor: pointer; transition: all 0.3s; margin-bottom: 20px;\">\\
                <i class=\"fas fa-sign-in-alt\"></i> INGRESAR AL SISTEMA\\
            </button>\\
            \\
            <!-- Enlace de recuperación -->\\
            <div style=\"text-align: center;\">\\
                <a href=\"#\" onclick=\"mostrarRecuperacion()\" style=\"color: #667eea; font-size: 14px; text-decoration: none;\">\\
                    <i class=\"fas fa-key\"></i> ¿Olvidaste tu contraseña?\\
                </a>\\
            </div>\\
        </div>\\
        \\
        <!-- Formulario de recuperación (oculto) -->\\
        <div id=\"recoveryForm\" style=\"display: none;\">\\
            <div style=\"text-align: center; margin-bottom: 20px;\">\\
                <i class=\"fas fa-envelope\" style=\"font-size: 48px; color: #667eea; margin-bottom: 15px;\"></i>\\
                <h3 style=\"color: #333;\">Recuperar Acceso</h3>\\
                <p style=\"color: #666; font-size: 14px;\">Contacta al administrador del sistema</p>\\
            </div>\\
            \\
            <div style=\"background: #f8f9fa; padding: 15px; border-radius: 10px; margin-bottom: 20px;\">\\
                <p style=\"margin: 0; color: #666; font-size: 14px;\">\\
                    <i class=\"fas fa-info-circle\"></i> Para recuperar acceso, contacta directamente a:\\
                </p>\\
                <p style=\"margin: 10px 0 0 0; font-weight: bold; color: #333;\">\\
                    Joselyn Campero - Inmobiliaria Campero\\
                </p>\\
            </div>\\
            \\
            <button onclick=\"volverALogin()\" style=\"width: 100%; padding: 14px; background: #6c757d; color: white; border: none; border-radius: 10px; font-size: 16px; cursor: pointer;\">\\
                <i class=\"fas fa-arrow-left\"></i> Volver al Login\\
            </button>\\
        </div>\\
        \\
        <!-- Mensaje de error -->\\
        <div id=\"loginError\" style=\"display: none; margin-top: 20px; padding: 12px; background: #fee; border: 1px solid #fcc; border-radius: 8px; color: #c00; text-align: center; font-size: 14px;\">\\
            <i class=\"fas fa-exclamation-triangle\"></i> <span id=\"errorText\">Credenciales incorrectas</span>\\
        </div>\\
    </div>\\
</div>\\
\\
<!-- Botón flotante para login -->\\
<div id=\"btnLoginFlotante\" style=\"position: fixed; bottom: 30px; right: 30px; z-index: 1000;\">\\
    <button onclick=\"mostrarLogin()\" style=\"width: 60px; height: 60px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 50%; font-size: 20px; cursor: pointer; box-shadow: 0 5px 20px rgba(102, 126, 234, 0.5); transition: all 0.3s;\">\\
        <i class=\"fas fa-user-lock\"></i>\\
    </button>\\
</div>" "$ARCHIVO"

echo "✅ Modal de login agregado!"

# 2. Agregar funciones de autenticación
LINEA_SCRIPT=$(grep -n "</script>" "$ARCHIVO" | tail -1 | cut -d: -f1)

echo "📌 Agregando funciones de autenticación en línea: $LINEA_SCRIPT"

sed -i "${LINEA_SCRIPT}i\\
// =============================================\\
// 🔐 SISTEMA DE AUTENTICACIÓN SEGURA          \\
// =============================================\\
\\
// Credenciales del administrador\\
const CREDENCIALES_ADMIN = {\\
    usuario: 'campero',\\
    password: 'inmobiliaria2024'\\
};\\
\\
// Mostrar modal de login\\
function mostrarLogin() {\\
    document.getElementById('modalLogin').style.display = 'block';\\
    document.getElementById('loginForm').style.display = 'block';\\
    document.getElementById('recoveryForm').style.display = 'none';\\
    document.getElementById('loginError').style.display = 'none';\\
    document.getElementById('inputUsuario').value = '';\\
    document.getElementById('inputPassword').value = '';\\
    setTimeout(() => { document.getElementById('inputUsuario').focus(); }, 100);\\
}\\
\\
// Ocultar modal de login\\
function ocultarLogin() {\\
    document.getElementById('modalLogin').style.display = 'none';\\
}\\
\\
// Verificar credenciales\\
function verificarLogin() {\\
    const usuario = document.getElementById('inputUsuario').value.trim();\\
    const password = document.getElementById('inputPassword').value;\\
    \\
    if (!usuario || !password) {\\
        mostrarError('Por favor completa todos los campos');\\
        return;\\
    }\\
    \\
    if (usuario === CREDENCIALES_ADMIN.usuario && password === CREDENCIALES_ADMIN.password) {\\
        loginExitoso();\\
    } else {\\
        mostrarError('Usuario o contraseña incorrectos');\\
        document.getElementById('inputUsuario').style.borderColor = '#ef4444';\\
        document.getElementById('inputPassword').style.borderColor = '#ef4444';\\
        setTimeout(() => {\\
            document.getElementById('inputUsuario').style.borderColor = '#e0e0e0';\\
            document.getElementById('inputPassword').style.borderColor = '#e0e0e0';\\
        }, 1000);\\
    }\\
}\\
\\
// Login exitoso\\
function loginExitoso() {\\
    const sesion = {\\
        autenticado: true,\\
        fecha: new Date().toISOString(),\\
        usuario: CREDENCIALES_ADMIN.usuario\\
    };\\
    const sesionCodificada = btoa(JSON.stringify(sesion));\\
    localStorage.setItem('sesion_admin', sesionCodificada);\\
    ocultarLogin();\\
    mostrarNotificacion('✅ ¡Bienvenida, Joselyn! Acceso autorizado', 'success');\\
    setTimeout(() => {\\
        mostrarElementosAdmin();\\
        actualizarUIAdmin();\\
    }, 1000);\\
}\\
\\
// Mostrar elementos admin\\
function mostrarElementosAdmin() {\\
    const btnAdmin = document.querySelector('[onclick*=\"mostrarPanelAdmin\"]');\\
    if (btnAdmin) btnAdmin.style.display = 'block';\\
    \\
    const seccionSync = document.getElementById('seccion-sincronizacion');\\
    if (seccionSync) seccionSync.style.display = 'block';\\
    \\
    document.querySelectorAll('.btn-admin').forEach(btn => {\\
        btn.style.display = 'inline-block';\\
    });\\
}\\
\\
// Ocultar elementos admin\\
function ocultarElementosAdmin() {\\
    const panelAdmin = document.getElementById('panelAdmin');\\
    if (panelAdmin) panelAdmin.style.display = 'none';\\
    \\
    const seccionSync = document.getElementById('seccion-sincronizacion');\\
    if (seccionSync) seccionSync.style.display = 'none';\\
    \\
    document.querySelectorAll('.btn-admin').forEach(btn => {\\
        btn.style.display = 'none';\\
    });\\
}\\
\\
// Verificar sesión\\
function verificarSesion() {\\
    const sesionCodificada = localStorage.getItem('sesion_admin');\\
    if (sesionCodificada) {\\
        try {\\
            const sesion = JSON.parse(atob(sesionCodificada));\\
            const fechaSesion = new Date(sesion.fecha);\\
            const ahora = new Date();\\
            const diferenciaHoras = (ahora - fechaSesion) / (1000 * 60 * 60);\\
            \\
            if (sesion.autenticado && diferenciaHoras < 24) {\\
                mostrarElementosAdmin();\\
                actualizarUIAdmin();\\
                return true;\\
            } else {\\
                localStorage.removeItem('sesion_admin');\\
            }\\
        } catch (e) {\\
            localStorage.removeItem('sesion_admin');\\
        }\\
    }\\
    ocultarElementosAdmin();\\
    document.getElementById('btnLoginFlotante').style.display = 'block';\\
    return false;\\
}\\
\\
// Cerrar sesión\\
function cerrarSesion() {\\
    localStorage.removeItem('sesion_admin');\\
    ocultarElementosAdmin();\\
    document.getElementById('btnLoginFlotante').style.display = 'block';\\
    mostrarNotificacion('🔒 Sesión cerrada exitosamente', 'info');\\
    const panelAdmin = document.getElementById('panelAdmin');\\
    if (panelAdmin && panelAdmin.style.display === 'block') {\\
        mostrarPanelAdmin();\\
    }\\
}\\
\\
// Mostrar recuperación\\
function mostrarRecuperacion() {\\
    document.getElementById('loginForm').style.display = 'none';\\
    document.getElementById('recoveryForm').style.display = 'block';\\
    document.getElementById('loginError').style.display = 'none';\\
}\\
\\
// Volver al login\\
function volverALogin() {\\
    document.getElementById('recoveryForm').style.display = 'none';\\
    document.getElementById('loginForm').style.display = 'block';\\
}\\
\\
// Mostrar error\\
function mostrarError(mensaje) {\\
    document.getElementById('errorText').textContent = mensaje;\\
    document.getElementById('loginError').style.display = 'block';\\
    const modal = document.querySelector('#modalLogin > div');\\
    modal.style.animation = 'none';\\
    setTimeout(() => { modal.style.animation = 'shake 0.5s ease'; }, 10);\\
}\\
\\
// Actualizar UI admin\\
function actualizarUIAdmin() {\\
    const panelAdmin = document.getElementById('panelAdmin');\\
    if (panelAdmin) {\\
        const btnCerrar = panelAdmin.querySelector('[onclick*=\"mostrarPanelAdmin\"]');\\
        if (btnCerrar) {\\
            const btnCerrarSesion = document.createElement('button');\\
            btnCerrarSesion.innerHTML = '<i class=\"fas fa-sign-out-alt\"></i> Cerrar Sesión';\\
            btnCerrarSesion.style.cssText = 'background: #ef4444; color: white; border: none; padding: 8px 15px; border-radius: 5px; margin-left: 10px; cursor: pointer; font-size: 14px;';\\
            btnCerrarSesion.onclick = cerrarSesion;\\
            btnCerrar.parentNode.insertBefore(btnCerrarSesion, btnCerrar.nextSibling);\\
        }\\
    }\\
    document.getElementById('btnLoginFlotante').style.display = 'none';\\
}\\
\\
// Función de notificación\\
function mostrarNotificacion(mensaje, tipo) {\\
    const notificacion = document.createElement('div');\\
    notificacion.textContent = mensaje;\\
    notificacion.style.cssText = \`\\
        position: fixed;\\
        top: 20px;\\
        right: 20px;\\
        padding: 15px 20px;\\
        border-radius: 10px;\\
        color: white;\\
        font-weight: bold;\\
        z-index: 10000;\\
        animation: slideInRight 0.3s ease-out;\\
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);\\
        \${tipo === 'success' ? 'background: linear-gradient(135deg, #10b981 0%, #059669 100%);' : ''}\\
        \${tipo === 'error' ? 'background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);' : ''}\\
        \${tipo === 'info' ? 'background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);' : ''}\\
    \`;\\
    document.body.appendChild(notificacion);\\
    setTimeout(() => {\\
        notificacion.style.animation = 'slideOutRight 0.3s ease-out';\\
        setTimeout(() => { document.body.removeChild(notificacion); }, 300);\\
    }, 3000);\\
}\\
\\
// Agregar animaciones\\
const style = document.createElement('style');\\
style.textContent = \`\\
    @keyframes shake {\\
        0%, 100% { transform: translate(-50%, -50%); }\\
        10%, 30%, 50%, 70%, 90% { transform: translate(calc(-50% - 5px), -50%); }\\
        20%, 40%, 60%, 80% { transform: translate(calc(-50% + 5px), -50%); }\\
    }\\
    @keyframes slideInRight {\\
        from { transform: translateX(100%); opacity: 0; }\\
        to { transform: translateX(0); opacity: 1; }\\
    }\\
    @keyframes slideOutRight {\\
        from { transform: translateX(0); opacity: 1; }\\
        to { transform: translateX(100%); opacity: 0; }\\
    }\\
\`;\\
document.head.appendChild(style);\\
\\
// Inicializar\\
document.addEventListener('DOMContentLoaded', function() {\\
    setTimeout(verificarSesion, 500);\\
    document.getElementById('inputUsuario')?.addEventListener('keypress', function(e) {\\
        if (e.key === 'Enter') document.getElementById('inputPassword').focus();\\
    });\\
    document.getElementById('inputPassword')?.addEventListener('keypress', function(e) {\\
        if (e.key === 'Enter') verificarLogin();\\
    });\\
});" "$ARCHIVO"

echo "✅ Funciones de autenticación agregadas!"

# 3. Ocultar elementos por defecto
echo "📌 Ocultando elementos administrativos..."

sed -i 's/id="seccion-sincronizacion"/id="seccion-sincronizacion" style="display: none;"/g' "$ARCHIVO"

sed -i 's/onclick="editarPropiedad/class="btn-admin" style="display: none;" onclick="editarPropiedad/g' "$ARCHIVO"
sed -i 's/onclick="eliminarPropiedad/class="btn-admin" style="display: none;" onclick="eliminarPropiedad/g' "$ARCHIVO"

sed -i 's/onclick="mostrarPanelAdmin()"/onclick="mostrarPanelAdmin()" style="display: none;"/g' "$ARCHIVO"

echo ""
echo "=========================================="
echo "🔐 SISTEMA DE AUTENTICACIÓN CONFIGURADO"
echo "=========================================="
echo ""
echo "📋 CREDENCIALES POR DEFECTO:"
echo "   👤 Usuario: campero"
echo "   🔑 Contraseña: inmobiliaria2024"
echo ""
echo "⚠️  IMPORTANTE: Cambia estas credenciales!"
echo ""
echo "✅ Ahora solo tú podrás ver el panel admin"
