ARG spark_image_tag=3.0.0-1-hadoop3.2-1.0

FROM artifacts.ggn.in.guavus.com:4244/spark:${spark_image_tag}

ARG spark_uid=185

USER root

RUN apt-get update && \
    apt-get -y install curl && \
    curl -fSL http://artifacts.ggn.in.guavus.com:8081/artifactory/libs-release-local/org/elasticsearch/elasticsearch-hadoop-core/7.8.1_3.0.0/elasticsearch-hadoop-core-7.8.1_3.0.0.jar -o elasticsearch-hadoop-core-7.8.1_3.0.0.jar && \
    curl -fSL http://artifacts.ggn.in.guavus.com:8081/artifactory/libs-release-local/org/elasticsearch/elasticsearch-hadoop-mr/7.8.1_3.0.0/elasticsearch-hadoop-mr-7.8.1_3.0.0.jar -o elasticsearch-hadoop-mr-7.8.1_3.0.0.jar && \
    curl -fSL http://artifacts.ggn.in.guavus.com:8081/artifactory/libs-release-local/org/elasticsearch/elasticsearch-hadoop-sql/7.8.1_3.0.0/elasticsearch-hadoop-sql-7.8.1_3.0.0.jar -o elasticsearch-hadoop-sql-7.8.1_3.0.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.11.832/aws-java-sdk-s3-1.11.832.jar -o aws-java-sdk-s3-1.11.832.jar && \
    curl -fSL https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.832/aws-java-sdk-1.11.832.jar -o aws-java-sdk-1.11.832.jar && \
    curl -fSL https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.11.832/aws-java-sdk-core-1.11.832.jar -o aws-java-sdk-core-1.11.832.jar && \
    curl -fSL https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-dynamodb/1.11.832/aws-java-sdk-dynamodb-1.11.832.jar -o aws-java-sdk-dynamodb-1.11.832.jar && \
    curl -fSL https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.8.0/commons-pool2-2.8.0.jar -o commons-pool2-2.8.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar -o hadoop-aws-3.2.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/org/apache/spark/spark-avro_2.12/3.0.0/spark-avro_2.12-3.0.0.jar -o spark-avro_2.12-3.0.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/org/apache/spark/spark-token-provider-kafka-0-10_2.12/3.0.0/spark-token-provider-kafka-0-10_2.12-3.0.0.jar -o spark-token-provider-kafka-0-10_2.12-3.0.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/net/java/dev/jets3t/jets3t/0.9.0/jets3t-0.9.0.jar -o jets3t-0.9.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.0.0/spark-sql-kafka-0-10_2.12-3.0.0.jar -o spark-sql-kafka-0-10_2.12-3.0.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/2.2.0/kafka-clients-2.2.0.jar -o kafka-clients-2.2.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/org/apache/spark/spark-streaming-kafka-0-10_2.12/3.0.0/spark-streaming-kafka-0-10_2.12-3.0.0.jar -o spark-streaming-kafka-0-10_2.12-3.0.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.13.0/jmx_prometheus_javaagent-0.13.0.jar -o jmx_prometheus_javaagent-0.13.0.jar && \
    curl -fSL https://repo1.maven.org/maven2/za/co/absa/abris_2.12/4.0.1/abris_2.12-4.0.1.jar -o abris_2.12-4.0.1.jar && \
    curl -fSL https://packages.confluent.io/maven/io/confluent/kafka-avro-serializer/5.3.4/kafka-avro-serializer-5.3.4.jar -o kafka-avro-serializer-5.3.4.jar && \
    curl -fSL https://packages.confluent.io/maven/io/confluent/kafka-schema-registry-client/5.3.4/kafka-schema-registry-client-5.3.4.jar -o kafka-schema-registry-client-5.3.4.jar && \
    curl -fSL https://packages.confluent.io/maven/io/confluent/common-config/5.3.4/common-config-5.3.4.jar -o common-config-5.3.4.jar && \
    curl -fSL https://packages.confluent.io/maven/io/confluent/common-utils/5.4.3/common-utils-5.4.3.jar -o common-utils-5.4.3.jar && \
    mv elasticsearch-hadoop-core-7.8.1_3.0.0.jar /opt/spark/jars/ && \
    mv elasticsearch-hadoop-mr-7.8.1_3.0.0.jar /opt/spark/jars/ && \
    mv elasticsearch-hadoop-sql-7.8.1_3.0.0.jar /opt/spark/jars/ && \
    mv aws-java-sdk-s3-1.11.832.jar /opt/spark/jars/ && \
    mv aws-java-sdk-1.11.832.jar /opt/spark/jars/ && \
    mv aws-java-sdk-core-1.11.832.jar /opt/spark/jars/ && \
    mv aws-java-sdk-dynamodb-1.11.832.jar /opt/spark/jars/ && \
    mv commons-pool2-2.8.0.jar /opt/spark/jars/ && \
    mv hadoop-aws-3.2.0.jar /opt/spark/jars/ && \
    mv spark-avro_2.12-3.0.0.jar /opt/spark/jars/ && \
    mv spark-token-provider-kafka-0-10_2.12-3.0.0.jar /opt/spark/jars/ && \
    mv jets3t-0.9.0.jar /opt/spark/jars/ && \
    mv spark-sql-kafka-0-10_2.12-3.0.0.jar /opt/spark/jars/ && \
    mv kafka-clients-2.2.0.jar /opt/spark/jars/ && \
    mv spark-streaming-kafka-0-10_2.12-3.0.0.jar /opt/spark/jars/ && \
    mv jmx_prometheus_javaagent-0.13.0.jar /opt/spark/jars/ && \
    mv abris_2.12-4.0.1.jar /opt/spark/jars/ && \
    mv kafka-avro-serializer-5.3.4.jar /opt/spark/jars/ && \
    mv kafka-schema-registry-client-5.3.4.jar /opt/spark/jars/ && \
    mv common-config-5.3.4.jar /opt/spark/jars/ && \
    mv common-utils-5.4.3.jar /opt/spark/jars/



ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER ${spark_uid}
