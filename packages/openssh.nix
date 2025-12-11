{
  termuxPkg,
  openssh,
  termux-auth,
  termuxPackageHook,
}:
openssh.overrideAttrs (old: {
  pname = "openssh-termux";
  nativeBuildInputs = old.nativeBuildInputs ++ [termuxPackageHook];
  buildInputs = old.buildInputs ++ [termux-auth];

  termuxPatches = [
    "${termuxPkg}/auth.c.patch"
    "${termuxPkg}/auth-passwd.c.patch"
    "${termuxPkg}/contrib_ssh-copy-id.patch"
    "${termuxPkg}/defines.h.patch"
    "${termuxPkg}/hostfile.c.patch"
    "${termuxPkg}/loginrec.c.patch"
    "${termuxPkg}/Makefile.in.patch"
    "${termuxPkg}/misc.c.patch"
    "${termuxPkg}/mux.c.patch"
    "${termuxPkg}/openbsd-compat_explicit_bzero.c.patch"
    "${termuxPkg}/openbsd-compat_xcrypt.c.patch"
    "${termuxPkg}/pathnames.h.patch"
    "${termuxPkg}/readconf.c.patch"
    "${termuxPkg}/servconf.c.patch"
    "${termuxPkg}/session.c.patch"
    "${termuxPkg}/sftp-server.c.patch"
    "${termuxPkg}/ssh-agent.c.patch"
    "${termuxPkg}/ssh_config.patch"
    "${termuxPkg}/sshd.8.patch"
    "${termuxPkg}/sshd-auth.c.patch"
    "${termuxPkg}/sshd_config.5.patch"
    "${termuxPkg}/sshd_config.patch"
    "${termuxPkg}/sshd.c.patch"
    "${termuxPkg}/sshd-session.c.patch"
    "${termuxPkg}/ssh-keygen.c.patch"
    "${termuxPkg}/sshpty.c.patch"
  ];
})
