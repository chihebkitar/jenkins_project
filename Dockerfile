ARG version="latest"
FROM nginx:${version}

LABEL maintainer="Kitar Chiheb"

RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*  # Fixed the rm command

RUN rm -rf /usr/share/nginx/html/* && \
    git clone https://github.com/chihebkitar/static-website.git /usr/share/nginx/html/

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/nginx", "-g", "daemon off;" ]
