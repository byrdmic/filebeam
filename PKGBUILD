pkgname=filebeam
pkgver=0.0.1
pkgrel=1
pkgdesc="A command-line tool for outputting contents of files"
arch=('any')
url="https://github.com/byrdmic/filebeam"
license=('GPL')
depends=('bash')
source=("$url/archive/v$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
  cd "$srcdir/$pkgname-$pkgver"

  # Install the script
  install -Dm755 filebeam.sh "$pkgdir/usr/bin/filebeam"
}
