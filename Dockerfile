FROM alpine:latest

RUN apk add --no-cache \
  curl \
  wget \
  bash \
  git \
  vim \
  jq \
  netcat-openbsd

RUN echo '#!/bin/sh' > /etc/profile.d/welcome.sh && \
  echo 'echo "================================================"' >> /etc/profile.d/welcome.sh && \
  echo 'echo "Welcome to Testing Environment, Ayush"' >> /etc/profile.d/welcome.sh && \
  echo 'echo "Tools: curl, wget, git, vim, jq, netcat"' >> /etc/profile.d/welcome.sh && \
  echo 'echo "================================================"' >> /etc/profile.d/welcome.sh && \
  chmod +x /etc/profile.d/welcome.sh

CMD ["/bin/sh", "-l"]
