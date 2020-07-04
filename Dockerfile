#
# Base image
#

FROM ubuntu

#
# Build the image layers
#

# Install required system packages (discovered by installing ocsigen interactively in running container)
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    gettext-base \
    libgdm-dev \
    libgmp-dev \
    libpcre3-dev \
    libssl-dev \
    m4 \
    perl \
    pkg-config \
    zlib1g-dev

RUN adduser --uid 1000 --disabled-password --gecos '' opam  \
    && passwd -l opam \
    && chown -R opam:opam /home/opam

# Initialise opam and install ocaml and ocsigen, answering all prompts with yes
# Disable sandboxing per https://github.com/ocaml/opam/issues/3498, https://github.com/ocaml/opam/issues/3424 
# Write opam env to bashrc
# If need to reinitialise opam, use --reinit as in: RUN opam init --disable-sandboxing --reinit -y
USER opam
ENV PATH='/home/opam/.opam/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
ENV CAML_LD_LIBRARY_PATH='/home/opam/.opam/default/lib/stublibs:/home/opam/.opam/default/lib/ocaml/stublibs:/home/opam/.opam/default/lib/ocaml:/home/opam/.opam/default/lib/ocaml/threads'


# Copy from current directory to image working directory
# Make script executable
# While building image layers, user is opam.  Heroku changes the user when container is started. 
WORKDIR /home/opam/ocsigen
COPY --chown=opam:opam entrypoint.sh .
COPY --chown=opam:opam ocsigen.conf .
COPY --chown=opam:opam ocsigen.conf.template .
COPY --chown=opam:opam www/* ./www/
RUN chmod +x entrypoint.sh

RUN mkdir -p /home/opam/.opam/default/bin/ \
/home/opam/.opam/default/lib/stublibs/ \
/home/opam/.opam/default/lib/ocaml/stublibs/ \
/home/opam/.opam/default/lib/ocsigenserver/var/log/ocsigenserver/ \
/home/opam/.opam/default/lib/ocsigenserver/var/lib/ocsigenserver/


COPY --chown=opam:opam bin/ /home/opam/.opam/default/bin/
COPY --chown=opam:opam lib/ /home/opam/.opam/default/lib/
COPY --chown=opam:opam etc/ocsigenserver/* /home/opam/.opam/default/lib/ocsigenserver/etc/ocsigenserver/

#
# Container runtime
#

# Entrypoint script prepares ocsigen.conf using container environment variables
ENTRYPOINT ["/home/opam/ocsigen/entrypoint.sh"]

# Get ocsigenserver going
CMD ["ocsigenserver", "-c","/home/opam/ocsigen/ocsigen.conf"]
#CMD bash