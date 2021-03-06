FROM jupyterhub/singleuser

# Update pip
RUN pip install --upgrade pip

#Create Exchange directory for nbgrader and make sure all users have permission
USER root
# remove existing directory, so we can start fresh
RUN rm -rf /srv/nbgrader
# create the exchange directory, with write permissions for everyone
RUN mkdir -p /srv/nbgrader/exchange
RUN chmod -R ugo+rw /srv/nbgrader/exchange

USER $NB_UID

# Install nbgrader
RUN pip install nbgrader

#Install nose, required for auto-grading
RUN pip install nose

# Create nbgrader profile and add nbgrader config
COPY nbgrader_config.py /etc/jupyter/

# Install the nbgrader extensions
RUN jupyter nbextension install --sys-prefix --py nbgrader
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader

USER root

# Configure container startup
CMD ["start-singleuser.sh"]

USER $NB_UID
