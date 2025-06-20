# Sử dụng image Jenkins LTS chính thức làm nền tảng
FROM jenkins/jenkins:lts

# Chuyển sang user root để cài đặt các gói
USER root

# Cài đặt Docker CLI và các phụ thuộc cần thiết
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# THÊM DÒNG NÀY ĐỂ TẠO NHÓM 'docker' NẾU NÓ CHƯA TỒN TẠI
RUN groupadd -f docker

# Thêm người dùng 'jenkins' vào nhóm 'docker'
RUN usermod -aG docker jenkins

# Chuyển lại về user mặc định của Jenkins
USER jenkins