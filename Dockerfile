FROM alpine as stage
ARG VERSION=latest
# zdefiniowanie zmiennych do pliku html tylko wersje sie podaje jako argument ENV 
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


