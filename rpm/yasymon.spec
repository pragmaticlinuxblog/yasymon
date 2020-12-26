Name: yasymon
Version: 0.1.0
Release: 1
Summary: Program for obtaining CPU, RAM and Swap usage information.  

License: MIT        
URL: https://github.com/pragmaticlinuxblog/yasymon            
Source0: yasymon-%{version}.tar.gz

BuildRequires: make gcc python3 python3-devel python3-virtualenv pandoc 

%define debug_package %{nil}

%description
Yasymon is a command line program for obtaining CPU, RAM and Swap related
system information. It can serve as a flexible building block for creating your
own system monitor tool.

%prep
%setup -q -n yasymon-%{version}

%build
make

%install
make install DESTDIR=%{buildroot}
install -D -m 644 docs/man/yasymon.1 %{buildroot}%{_mandir}/man1/yasymon.1

%clean
make clean

%files
%defattr(-,root,root)
%{_bindir}/yasymon
%{_mandir}/man1/yasymon.1

%changelog
* Sat Dec 26 12:05:59 CET 2020 PragmaticLinux <info@pragmaticlinux.com> - 0.1.0-1
- Initial version of the package

