FROM cirrusci/flutter:stable

WORKDIR /app

COPY . .

RUN flutter pub get

RUN flutter build web --release

EXPOSE 8080

CMD ["/usr/bin/python3", "-m", "http.server", "8080", "--directory", "build/web"]
