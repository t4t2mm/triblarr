FROM ubuntu:latest

# Install minimal dependencies
RUN apt update -y \
  && apt -y install curl \
  && apt-get install -y gosu

# Download and intall tribler
RUN tag=`basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/Tribler/tribler/releases/latest)` \
  && vlesstag=$(echo $tag | cut -c2-) \
  && echo "Tag with v = ${tag}, tag without v = ${vlesstag}" \
  && cd /home/ubuntu \
  && curl -LO "https://github.com/Tribler/tribler/releases/download/${tag}/tribler_${vlesstag}_x64.deb" \
  && apt install -y "./tribler_${vlesstag}_x64.deb" \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Import entrypoint script in the image and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
