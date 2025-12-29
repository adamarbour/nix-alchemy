{
  boot.kernel.sysctl = {
    # Prevent boot console log leaking information
    "kernel.printk" = "3 3 3 3";
    "fs.suid_dumpable" = 0;
    # prevent pointer leaks
    "kernel.kptr_restrict" = 2;
    # restrict kernel log to CAP_SYSLOG capability
    "kernel.dmesg_restrict" = 1;
    # restrict eBPF to the CAP_BPF capability
    "kernel.unprivileged_bpf_disabled" = 1;
    # should be enabled along with bpf above
    "net.core.bpf_jit_harden" = 2;
    # kexec is used to boot another kernel during runtime and can be abused
    "kernel.kexec_load_disabled" = 1;
    # Kernel self-protection
    # SysRq exposes a lot of potentially dangerous debugging functionality to unprivileged users
    # 4 makes it so a user can only use the secure attention key. A value of 0 would disable completely
    "kernel.sysrq" = 4;
  };
}
