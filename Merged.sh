#!/bin/bash

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar LibreOffice
echo "Instalando LibreOffice..."
sudo apt install -y libreoffice

# Verificar la instalación
echo "Verificando la instalación de LibreOffice..."
libreoffice --version

# Crear acceso directo en el menú de aplicaciones (opcional)
# Esto normalmente no es necesario ya que LibreOffice se integra automáticamente en el menú de aplicaciones de Ubuntu
# Si se desea agregar manualmente, se pueden crear archivos .desktop

echo "Instalación de LibreOffice completada. Puedes iniciar la aplicación desde el menú de aplicaciones o ejecutando 'libreoffice' en la terminal."



##########################################################
##########################################################


#!/bin/bash

# Definir la ruta del directorio de la herramienta y del entorno virtual
TOOL_DIR="/home/osintboxvm/Desktop/Tools"
INSTALL_DIR="$TOOL_DIR/.NetworkXTool"
VENV_DIR="$INSTALL_DIR/myenv"

# Asegurarse de que el directorio de instalación existe
mkdir -p "$INSTALL_DIR"

# Instalar python3-venv para crear entornos virtuales
sudo apt install -y python3-venv

# Crear un entorno virtual en la ruta especificada
python3 -m venv "$VENV_DIR"

# Activar el entorno virtual
source "$VENV_DIR/bin/activate"

# Instalar networkx con todas las dependencias opcionales
pip install networkx[default]

# Verificar la instalación de networkx
python -c "import networkx as nx; print(nx.__version__)"

# Desactivar el entorno virtual
deactivate

# Crear el script para ejecutar NetworkX en el entorno virtual
echo "Creando el script de ejecución para NetworkX en $TOOL_DIR..."
cat << EOF > "$TOOL_DIR/run_networkx.sh"
#!/bin/bash

# Ruta al entorno virtual
VENV_DIR="$VENV_DIR"

# Verificar si el entorno virtual existe
if [ ! -d "\$VENV_DIR" ]; then
  echo "El entorno virtual no existe. Ejecuta el script de instalación para crear el entorno virtual primero."
  exit 1
fi

# Activar el entorno virtual
echo "Activando el entorno virtual para NetworkX..."
source "\$VENV_DIR/bin/activate"

# Mantener la sesión en el entorno virtual
echo "El entorno virtual de NetworkX está activado. Puedes comenzar a trabajar."
\$SHELL
EOF

# Hacer el script ejecutable
chmod +x "$TOOL_DIR/run_networkx.sh"

# Mensaje de finalización
echo "Instalación de NetworkX completada."
echo "Puedes ejecutar el entorno virtual utilizando el script creado en $TOOL_DIR/run_networkx.sh."


##########################################################
##########################################################

#!/bin/bash

# Variables de configuración
INSTALL_DIR="/home/osintboxvm/Desktop/Tools/.TheHarvester"  # Carpeta oculta
VENV_DIR="$INSTALL_DIR/venv"

# Asegurar que el directorio de instalación existe
mkdir -p "$INSTALL_DIR"

# Instalar dependencias necesarias
echo "Instalando dependencias necesarias..."
sudo apt install -y git python3 python3-venv

# Clonar el repositorio de TheHarvester
echo "Clonando el repositorio de TheHarvester..."
git clone https://github.com/laramies/theHarvester.git "$INSTALL_DIR"

# Navegar al directorio de TheHarvester
cd "$INSTALL_DIR"

# Crear un entorno virtual
echo "Creando un entorno virtual en $VENV_DIR..."
python3 -m venv "$VENV_DIR"

# Activar el entorno virtual
source "$VENV_DIR/bin/activate"

# Instalar dependencias de Python dentro del entorno virtual
echo "Instalando dependencias de Python..."
pip install -r requirements/base.txt

# Desactivar el entorno virtual
deactivate

# Crear directorio Tools en el escritorio si no existe
TOOLS_DIR=~/Desktop/Tools
mkdir -p "$TOOLS_DIR"

# Crear el script para ejecutar TheHarvester en el entorno virtual
echo "Creando el script de ejecución para TheHarvester en $TOOLS_DIR..."
cat << EOF > "$TOOLS_DIR/run_theharvester.sh"
#!/bin/bash

# Ruta al entorno virtual
VENV_DIR="$INSTALL_DIR/venv"

# Verificar si el entorno virtual existe
if [ ! -d "\$VENV_DIR" ]; then
  echo "El entorno virtual no existe. Ejecuta el script de instalación para crear el entorno virtual primero."
  exit 1
fi

# Activar el entorno virtual
echo "Activando el entorno virtual para TheHarvester..."
source "\$VENV_DIR/bin/activate"

# Navegar al directorio de TheHarvester
cd "$INSTALL_DIR"

# Ejecutar TheHarvester con los argumentos proporcionados
echo "Ejecutando TheHarvester..."
python3 theHarvester.py "\$@"

EOF

# Hacer el script ejecutable
chmod +x "$TOOLS_DIR/run_theharvester.sh"

# Mensaje de finalización
echo "Instalación de TheHarvester completada."
echo "Puedes ejecutar TheHarvester utilizando el script creado en $TOOLS_DIR/run_theharvester.sh."



##########################################################
##########################################################

#!/bin/bash

# Instalar Wireshark y sus dependencias
sudo apt install -y wireshark

# Configurar permisos para capturar paquetes sin ser usuario root
sudo dpkg-reconfigure wireshark-common

# Agregar el usuario actual al grupo wireshark
sudo usermod -aG wireshark $(whoami)

# Crear el acceso directo en el escritorio
cat <<EOF > ~/Desktop/wireshark.desktop
[Desktop Entry]
Version=1.0
Name=Wireshark
Comment=Captura y análisis de tráfico de red
Exec=wireshark
Icon=/usr/share/icons/hicolor/256x256/apps/org.wireshark.Wireshark.png
Terminal=false
Type=Application
Categories=Network;Application;
EOF

# Hacer el archivo .desktop ejecutable
chmod +x ~/Desktop/wireshark.desktop

# Marcar el archivo como confiable
gio set ~/Desktop/wireshark.desktop metadata::trusted true

# Mensaje de finalización
echo "La instalación de Wireshark se ha completado exitosamente."
echo "Es posible que necesites reiniciar tu sesión o el sistema para aplicar los cambios de permisos."
echo "Para iniciar Wireshark, usa el comando 'wireshark' o busca Wireshark en tu lista de aplicaciones."



##########################################################
##########################################################

#!/bin/bash

# Instalar dependencias necesarias
sudo apt install -y git python3 python3-pip python3-venv jq lolcat golang

# Crear carpeta oculta para karma_v2 y su entorno virtual
mkdir -p ~/.karma_v2

# Clonar el repositorio de karma_v2 en la carpeta oculta
git clone https://github.com/Dheerajmadhukar/karma_v2.git ~/.karma_v2

# Crear un entorno virtual para karma_v2 en la carpeta oculta
python3 -m venv ~/.karma_v2/karma-env

# Activar el entorno virtual
source ~/.karma_v2/karma-env/bin/activate

# Instalar setuptools para evitar errores relacionados con pkg_resources
pip install setuptools

# Instalar módulos de Python necesarios
pip install shodan mmh3

# Desactivar el entorno virtual
deactivate

# Configurar el entorno Go correctamente
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
echo "export GOPATH=\$HOME/go" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc
source ~/.bashrc

# Crear un entorno de módulo Go temporal para instalar httprobe
mkdir -p ~/go-temp
cd ~/go-temp
go mod init temp-module

# Intentar instalar httprobe
echo "Intentando instalar httprobe..."
GO111MODULE=on go install github.com/tomnomnom/httprobe@latest

# Verificar instalación de httprobe
if ! command -v httprobe &> /dev/null
then
    echo "Error: httprobe no se instaló correctamente. Intentando solucionarlo nuevamente."
    GO111MODULE=on go install github.com/tomnomnom/httprobe@latest
    if ! command -v httprobe &> /dev/null
    then
        echo "Error: No se pudo instalar httprobe después de intentar solucionarlo. Por favor, verifica tu configuración de Go y PATH."
        exit 1
    fi
else
    echo "httprobe se instaló correctamente."
fi

# Instalar Interlace
echo "Instalando Interlace..."
git clone https://github.com/codingo/Interlace.git ~/.karma_v2/Interlace
cd ~/.karma_v2/Interlace
sudo python3 setup.py install

# Volver al directorio de karma_v2
cd ~/.karma_v2

# Instalar nuclei
echo "Instalando nuclei..."
GO111MODULE=on go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Instalar anew
echo "Instalando anew..."
GO111MODULE=on go install -v github.com/tomnomnom/anew@master

# Hacer que el binario karma_v2 sea ejecutable
chmod +x ~/.karma_v2/karma_v2

# Crear el script para ejecutar karma_v2 en el entorno virtual
TOOLS_DIR=~/Desktop/Tools
mkdir -p "$TOOLS_DIR"
echo "Creando el script de ejecución para karma_v2 en $TOOLS_DIR..."
cat << EOF > "$TOOLS_DIR/run_karma_v2.sh"
#!/bin/bash

# Ruta al entorno virtual
VENV_DIR="\$HOME/.karma_v2/karma-env"

# Verificar si el entorno virtual existe
if [ ! -d "\$VENV_DIR" ]; then
  echo "El entorno virtual no existe. Ejecuta el script de instalación para crear el entorno virtual primero."
  exit 1
fi

# Activar el entorno virtual
echo "Activando el entorno virtual para karma_v2..."
source "\$VENV_DIR/bin/activate"

# Ejecutar el binario karma_v2 con los argumentos proporcionados
echo "Ejecutando karma_v2..."
cd "\$HOME/.karma_v2"
./karma_v2 "\$@"

# Mantener el entorno virtual activo
exec bash

echo "karma_v2 ha terminado de ejecutarse. El entorno virtual permanece activo."
EOF

# Hacer el script ejecutable
chmod +x "$TOOLS_DIR/run_karma_v2.sh"

# Mensaje de finalización
echo "La instalación de karma_v2 y sus dependencias se ha completado."
echo "El script de ejecución de karma_v2 se ha creado en $TOOLS_DIR."
echo "Para usar karma_v2, ejecuta el script 'run_karma_v2.sh' desde $TOOLS_DIR."


##########################################################
##########################################################

# Crear carpeta de MetabigorGit (oculta)
mkdir -p /home/osintboxvm/Desktop/Tools/.metabigorGit

# Clonar el repositorio de Metabigor en la carpeta oculta
git clone https://github.com/j3ssie/metabigor.git /home/osintboxvm/Desktop/Tools/.metabigorGit

# Cambiar al directorio del repositorio clonado
cd /home/osintboxvm/Desktop/Tools/.metabigorGit || { echo "Error: No se pudo cambiar al directorio .metabigorGit"; exit 1; }

# Instalar Go usando Snap
sudo snap install go --classic

# Compilar e instalar Metabigor
go build -o metabigor main.go

# Mover el binario a la carpeta de herramientas directamente
mv metabigor /home/osintboxvm/Desktop/Tools/

# Verificación de la instalación
if [ -f /home/osintboxvm/Desktop/Tools/metabigor ]; then
  echo "Metabigor se ha instalado correctamente."
else
  echo "La instalación de Metabigor falló."
fi

# Nota sobre cómo ejecutar Metabigor
echo "Para ejecutar Metabigor, navega al directorio 'Tools' y ejecuta:"
echo "  ./metabigor"


##########################################################
##########################################################


# Instalar dependencias necesarias para compilar graph-tool
sudo apt install -y \
    build-essential \
    python3-dev \
    python3-pip \
    python3-matplotlib \
    python3-numpy \
    python3-scipy \
    python3-cairo \
    python3-pyqt5 \
    python3-zmq \
    libboost-all-dev \
    libcgal-dev \
    libsparsehash-dev \
    libxml2-dev \
    libxslt1-dev \
    libgraphviz-dev \
    libexpat1-dev \
    cmake

# Agregar el PPA de graph-tool
sudo add-apt-repository -y ppa:agronholm/graph-tool

# Instalar graph-tool
sudo apt install -y python3-graph-tool

# Verificar la instalación
python3 -c "import graph_tool.all as gt; print(gt.__version__)"


##########################################################
##########################################################
#!/bin/bash

# Instalar dependencias necesarias
echo "Instalando dependencias necesarias..."
sudo apt install -y curl apt-transport-https software-properties-common lsb-release gnupg

# Descargar el paquete de instalación de Nessus
echo "Descargando el paquete de instalación de Nessus..."
wget -O nessus.deb "https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/23895/download?i_agree_to_tenable_license_agreement=true"

# Instalar Nessus
echo "Instalando Nessus..."
sudo dpkg -i nessus.deb

# Corregir dependencias, si es necesario
echo "Corrigiendo dependencias..."
sudo apt --fix-broken install -y

# Habilitar y arrancar el servicio de Nessus
echo "Habilitando y arrancando el servicio de Nessus..."
sudo systemctl enable nessusd
sudo systemctl start nessusd

# Información final
echo "La instalación de Nessus está completa."
echo "Puedes acceder a la interfaz web de Nessus en https://localhost:8834"
echo "Asegúrate de abrir el puerto 8834 en el firewall si accedes remotamente."

# Crear un script para iniciar Nessus y abrir el navegador
echo "Creando script para iniciar Nessus y abrir la interfaz web..."
cat << EOF > ~/Desktop/Tools/start_nessus.sh
#!/bin/bash

# Iniciar el servicio de Nessus
echo "Iniciando el servicio de Nessus..."
sudo systemctl start nessusd

# Esperar a que el servicio esté completamente levantado
sleep 5

# Abrir el navegador web con la interfaz de Nessus
echo "Abriendo la interfaz web de Nessus..."
xdg-open https://localhost:8834

EOF

# Hacer el script ejecutable
chmod +x ~/Desktop/Tools/start_nessus.sh

# Fin del script
echo "Instalación finalizada. Puedes iniciar Nessus y abrir la interfaz web con el script 'start_nessus.sh' en ~/Desktop/Tools/"


##########################################################
##########################################################


# Instalar exiftool desde los repositorios oficiales
sudo apt install -y exiftool

# Verificar la instalación
exiftool -ver



##########################################################
##########################################################

# Instalar dependencias necesarias
sudo apt install -y python3 python3-pip python3-venv

# Crear un entorno virtual para h8mail
python3 -m venv ~/.h8mail-env  # La carpeta de entorno virtual se crea oculta con el prefijo "."

# Activar el entorno virtual
source ~/.h8mail-env/bin/activate

# Instalar h8mail en el entorno virtual
pip install h8mail

# Desactivar el entorno virtual
deactivate

# Mensaje de finalización
echo "La instalación de h8mail se ha completado."

# Crear directorio Tools en el escritorio si no existe
TOOLS_DIR=~/Desktop/Tools
mkdir -p "$TOOLS_DIR"

# Crear el script para ejecutar h8mail en el entorno virtual
echo "Creando el script de ejecución para h8mail en $TOOLS_DIR..."
cat << EOF > "$TOOLS_DIR/run_h8mail.sh"
#!/bin/bash

# Ruta al entorno virtual
VENV_DIR="$HOME/.h8mail-env"

# Verificar si el entorno virtual existe
if [ ! -d "\$VENV_DIR" ]; then
  echo "El entorno virtual no existe. Ejecuta el script de instalación para crear el entorno virtual primero."
  exit 1
fi

# Activar el entorno virtual
echo "Activando el entorno virtual para h8mail..."
source "\$VENV_DIR/bin/activate"

# Ejecutar h8mail con los argumentos proporcionados
echo "Ejecutando h8mail..."
h8mail "\$@"

EOF

# Hacer el script ejecutable
chmod +x "$TOOLS_DIR/run_h8mail.sh"

# Mensaje de finalización
echo "El script de ejecución de h8mail se ha creado en $TOOLS_DIR."





##########################################################
##########################################################

# Instalar dependencias necesarias
sudo apt install -y openjdk-11-jdk wget

# Descargar Maltego
MALTEGO_URL="https://downloads.maltego.com/maltego-v4/linux/Maltego.v4.7.0.deb"
wget $MALTEGO_URL -O /tmp/maltego.deb

# Verificar si la descarga fue exitosa
if [ $? -ne 0 ]; then
    echo "Error al descargar Maltego. Por favor, verifica la URL."
    exit 1
fi

# Instalar Maltego
sudo dpkg -i /tmp/maltego.deb

# Solucionar posibles dependencias faltantes
sudo apt-get install -f -y

# Limpiar archivos temporales
rm /tmp/maltego.deb

# Confirmar instalación y crear acceso directo
if command -v maltego &> /dev/null
then
    echo "Maltego ha sido instalado exitosamente."

    # Crear acceso directo en el escritorio
    echo "Creando acceso directo en el escritorio para Maltego..."
    cat << EOF > ~/Desktop/Maltego.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Maltego
Comment=Herramienta de análisis de enlaces e inteligencia
Exec=/usr/bin/maltego
Icon=/usr/share/pixmaps/maltego.png
Terminal=false
Categories=Network;Security;
EOF

    # Hacer el archivo .desktop ejecutable
    chmod +x ~/Desktop/Maltego.desktop

    # Hacer el acceso directo confiable
    gio set ~/Desktop/Maltego.desktop metadata::trusted true

    echo "Acceso directo de Maltego creado en el escritorio."

else
    echo "Hubo un problema al instalar Maltego."
fi

# Mensaje de finalización
echo "La instalación de Maltego se ha completado. Puedes encontrar Maltego en el menú de aplicaciones."



##########################################################
##########################################################

# Instalar Chromium
sudo apt install -y chromium-browser

# Confirmar instalación
if command -v chromium-browser &> /dev/null
then
    echo "Chromium ha sido instalado exitosamente."

    # Crear acceso directo en el escritorio
    echo "Creando acceso directo en el escritorio para Chromium..."
    cat << EOF > ~/Desktop/Chromium-Browser.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Chromium Browser
Comment=Navegador web rápido y seguro
Exec=/usr/bin/chromium-browser %U
Icon=/usr/share/icons/hicolor/128x128/apps/chromium-browser.png
Terminal=false
Categories=Network;WebBrowser;
EOF

    # Hacer el archivo .desktop ejecutable
    chmod +x ~/Desktop/Chromium-Browser.desktop

    # Hacer el acceso directo confiable
    gio set ~/Desktop/Chromium-Browser.desktop metadata::trusted true

    echo "Acceso directo de Chromium Browser creado en el escritorio."

else
    echo "Hubo un problema al instalar Chromium."
fi



##########################################################
##########################################################

# Instalar paquetes necesarios
sudo apt install -y curl apt-transport-https

# Agregar la clave GPG de Brave
curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/brave-browser-archive-keyring.gpg

# Agregar el repositorio de Brave a la lista de fuentes
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Actualizar la lista de paquetes nuevamente
sudo apt update

# Instalar Brave
sudo apt install -y brave-browser

# Confirmar instalación
echo "Brave Browser ha sido instalado exitosamente."

# Crear acceso directo en el escritorio
echo "Creando acceso directo en el escritorio para Brave Browser..."
cat << EOF > ~/Desktop/Brave-Browser.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Brave Browser
Comment=Navegador web rápido, privado y seguro
Exec=/usr/bin/brave-browser-stable %U
Icon=/usr/share/icons/hicolor/128x128/apps/brave-browser.png
Terminal=false
Categories=Network;WebBrowser;
EOF

# Hacer el archivo .desktop ejecutable
chmod +x ~/Desktop/Brave-Browser.desktop

# Hacer el acceso directo confiable
gio set ~/Desktop/Brave-Browser.desktop metadata::trusted true

echo "Acceso directo de Brave Browser creado en el escritorio."



##########################################################
##########################################################
#!/bin/bash

# Variables de configuración
INSTALL_DIR="/home/osintboxvm/.Cytoscape_v3.10.2"  # Directorio oculto
CYTOSCAPE_VERSION=3.10.2
CYTOSCAPE_URL="https://github.com/cytoscape/cytoscape/releases/download/3.10.2/Cytoscape_3_10_2_unix.sh"
USER_HOME="/home/osintboxvm"

# Instalar Java 17
echo "Instalando Java 17..."
sudo apt install -y openjdk-17-jdk

# Verificar la instalación de Java
echo "Verificando la instalación de Java..."
java -version

# Definir la variable INSTALL4J_JAVA_HOME
export INSTALL4J_JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo "Definiendo INSTALL4J_JAVA_HOME a $INSTALL4J_JAVA_HOME"

# Descargar Cytoscape
echo "Descargando Cytoscape versión $CYTOSCAPE_VERSION..."
curl -L -o cytoscape_unix.sh "$CYTOSCAPE_URL"

# Hacer el instalador ejecutable
echo "Haciendo el instalador ejecutable..."
chmod +x cytoscape_unix.sh

# Crear directorio de instalación oculto
echo "Creando el directorio de instalación en $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

# Instalar Cytoscape
echo "Instalando Cytoscape en $INSTALL_DIR..."
sudo ./cytoscape_unix.sh -q -dir "$INSTALL_DIR"

# Verificar la instalación
if [ -d "$INSTALL_DIR" ]; then
  echo "Cytoscape se ha instalado correctamente en $INSTALL_DIR."
else
  echo "Error: La instalación de Cytoscape no se completó correctamente."
  exit 1
fi

# Cambiar el propietario de los archivos instalados al usuario actual
sudo chown -R $(whoami):$(whoami) "$INSTALL_DIR"

# Crear archivo .desktop para lanzar Cytoscape
echo "Creando acceso directo de escritorio para Cytoscape..."
cat << EOF > $USER_HOME/Desktop/Cytoscape.desktop
[Desktop Entry]
Type=Application
Terminal=false
Name=Cytoscape
Icon=$INSTALL_DIR/framework/cytoscape_logo_512.png
Exec=$INSTALL_DIR/Cytoscape
Comment=Launch Cytoscape
Categories=Science;Bioinformatics;
EOF

# Hacer el archivo .desktop ejecutable
chmod +x $USER_HOME/Desktop/Cytoscape.desktop
echo "Acceso directo de Cytoscape creado en el escritorio."

# Hacer el acceso directo confiable
gio set $USER_HOME/Desktop/Cytoscape.desktop metadata::trusted true

# Limpiar archivos temporales
echo "Limpiando archivos temporales..."
rm cytoscape_unix.sh

# Notificación de finalización
echo "Instalación de Cytoscape $CYTOSCAPE_VERSION completada. Puedes iniciar la aplicación desde el acceso directo en el escritorio."


##########################################################
##########################################################