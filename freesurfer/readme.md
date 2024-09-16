# Welcome to the Resiliency projects FreeSurfer primer!
> I have no idea what I'm doing!
## Join me as we explore how to use FreeSurfer in a virtual machine running on a high-performance computing (HPC) cluster managed by a type-1 hypervisor, using a Singularity image!

First, we must create the singularity image within the VM. If you do not have access to singularity (e.g. if you are on a local machine), you can instead create a docker image of freesurfer. We are simply pulling the image from the [dockerhub repository](https://hub.docker.com/r/freesurfer/freesurfer/).

Using singularity, we can create the image with

```
singularity pull docker://freesurfer/freesurfer:7.2.0
```

- replace 7.2.0 with whatever version you prefer. Available versions are listed [here](https://hub.docker.com/r/freesurfer/freesurfer/tags)
