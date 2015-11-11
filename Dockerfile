FROM tutum/apache-php
RUN rm -rf /var/lib/apt/lists/*
RUN rm -fr /app
ADD . /app
RUN chmod -R 777 /app
RUN bash /app/run.sh
