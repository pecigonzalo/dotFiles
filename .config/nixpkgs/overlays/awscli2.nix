self: super:
{
  awscli2 = super.awscli2.overrideAttrs (old: {
    # postPatch = ''
    #   substituteInPlace setup.py --replace "awscrt==0.11.13" "awscrt>=0.11.13"
    #   substituteInPlace setup.py --replace "colorama>=0.2.5,<0.4.4" "colorama>=0.2.5"
    #   substituteInPlace setup.py --replace "cryptography>=3.3.2,<3.4.0" "cryptography>=3.3.2"
    #   substituteInPlace setup.py --replace "docutils>=0.10,<0.16" "docutils>=0.10"
    #   substituteInPlace setup.py --replace "ruamel.yaml>=0.15.0,<0.16.0" "ruamel.yaml>=0.15.0"
    #   substituteInPlace setup.py --replace "wcwidth<0.2.0" "wcwidth"
    #   substituteInPlace setup.py --replace "s3transfer<0.5.0,>=0.4.2" "s3transfer"
    # '';
  });
}
