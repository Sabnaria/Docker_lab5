# Docker_lab5

1. Treść Dockerfile z opisem:
---
```
FROM alpine as stage
ARG VERSION=latest
#zdefiniowanie zmiennych do pliku html tylko wersje sie podaje jako argument ENV 
ARG IP_ADDRESS=127.0.0.1
ARG HOSTNAME=localhost
ENV APP_VERSION=${VERSION}
#wybranie sciezki app 
WORKDIR /app
RUN echo "<h1> Adres IP: ${IP_ADDRESS}, Nazwa hosta: ${HOSTNAME}, wersja: ${VERSION}</h1>" > index.html 
#stworzenie pliku html z informacjami o wersji, adresie IP i nazwie hosta

#druga faza budowania 
FROM nginx:alpine as stage1
WORKDIR /app
#kopiujemy z wczesniejszego stage'a plik html do folderu nginx'a "html"
COPY --from=stage /app/index.html /usr/share/nginx/html/index.html
#instalujemy curl'a
RUN apk add --no-cache curl

EXPOSE 80
#ustawiamy klasycznego healtcheck'a
HEALTHCHECK --interval=10s --timeout=10s --start-period=2s --retries=3 \
    CMD curl -f http://localhost/ || exit 1
#uruchamiamy nginx'a 
CMD ["nginx", "-g", "daemon off;"]
```
---
2. Polecenie użyte do budowania obrazu:
```
docker build --build-arg VERSION=v1.0.0 -f Dockerfile -t lab5 .
```
---
3. Polecenie uruchamiające serwer:
```
docker run -d -p 8080:80 lab5
```
4. Polecenie potwierdzajace działanie kontenera
```
lab5% docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS                    PORTS                                     NAMES
11438b310c51   lab5      "/docker-entrypoint.…"   27 minutes ago   Up 27 minutes (healthy)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   lucid_perlman
```
Widzimy że status jest `healthy` co oznacza że kontener prawidłowo pracuje
5. Polecenie curl pokazujące prawidłowe funkcjonowanie serwera
```
Studia/lab5_examples/lab5% curl http://localhost:8080                                     
<h1> Adres IP: 127.0.0.1, Nazwa hosta: localhost, wersja: v1.0.0</h1>
```
