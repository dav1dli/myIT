microcontainer=$(buildah from registry.access.redhat.com/ubi8/ubi-micro)
yum install \
    --installroot $micromount \
    --releasever 8 \
    --setopt install_weak_deps=false \
    --nodocs -y \
    bind
yum clean all --installroot $micromount
buildah umount $microcontainer
buildah commit $microcontainer ubi-micro-bind