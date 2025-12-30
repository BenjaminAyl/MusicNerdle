# Backend service
docker_build('backend', './backend')
k8s_yaml('k8s/backend.yaml')
k8s_resource('backend', port_forwards=8080)

# Frontend service
docker_build('frontend', './frontend')
k8s_yaml('k8s/frontend.yaml')
k8s_resource('frontend', port_forwards=3000)

# Optional database service
# docker_build('db', './db')
# k8s_yaml('k8s/db.yaml')
# k8s_resource('db', port_forwards=5432)  # or whatever port your DB uses


