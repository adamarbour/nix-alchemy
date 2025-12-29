{
  boot.kernel.sysfs = {
    # enable transparent hugepages with deferred defragmentaion
    kernel.mm.transparent_hugepage = {
      enabled = "always";
      defrag = "defer";
      shmem_enabled = "within_size";
    };
  };
}
