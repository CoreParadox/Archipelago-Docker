FROM python:3.11.8

#clone archipelago
RUN mkdir -p /Archipelago
RUN git clone --depth 1 --branch 0.5.0 https://github.com/ArchipelagoMW/Archipelago.git /Archipelago

#clone and unzip Enemizer
RUN wget https://github.com/Ijwu/Enemizer/releases/download/7.1/ubuntu.16.04-x64.zip;\
    mkdir -p /Archipelago/EnemizerCLI;\
    unzip -u ubuntu.16.04-x64.zip -d /Archipelago/EnemizerCLI;\
    chmod -R 777 /Archipelago/EnemizerCLI;\
    rm ubuntu.16.04-x64.zip

#clone and untar SNI
RUN wget https://github.com/alttpo/sni/releases/download/v0.0.97/sni-v0.0.97-linux-amd64.tar.xz;\
    mkdir -p /Archipelago/SNI;\
    tar -xJf sni-v0.0.97-linux-amd64.tar.xz -C /Archipelago/SNI;\
    chmod -R 777 /Archipelago/SNI;\
    rm sni-v0.0.97-linux-amd64.tar.xz

#install C compiler
RUN apt install gcc -y

#create and activate venv
RUN python -m venv /archipelagoenv/; . /archipelagoenv/bin/activate

WORKDIR /Archipelago/

#install requirements
RUN pip install -r WebHostLib/requirements.txt
RUN python ModuleUpdate.py -y
RUN cythonize -b -i _speedups.pyx

RUN --network=host

EXPOSE 80/tcp
EXPOSE 80/udp

CMD python WebHost.py