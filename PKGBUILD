# Maintainer: Joakim Reinert <mail+aur@jreinert.com>
_name=audition
pkgname=${_name}-git
pkgver=v0.1.17.r32.ga78a687
pkgrel=1
pkgdesc="Simple now-playing server"
arch=(i686 x86_64)
url='https://github.com/jreinert/audition'
license=(MIT)
depends=('gc' 'libevent' 'libyaml' 'pcre')
makedepends=('crystal' 'shards')
conflicts=('audition-bin')
provides=('audition')
source=("${_name}::git+https://github.com/jreinert/audition")
sha256sums=(SKIP)

pkgver() {
  cd "$_name"
  git describe --long | sed 's/\([^-]*-g\)/r\1/;s/-/./g'
}

build() {
  cd "$_name"
  shards
  shards build --release
}

package() {
  cd "$_name"
  install -Dm755 bin/audition "$pkgdir/usr/bin/audition"
  install -Dm644 audition.service "$pkgdir/usr/lib/systemd/system/audition.service"
  install -Dm644 LICENSE "$pkgdir"/usr/share/licenses/amber_cmd/LICENSE
}
