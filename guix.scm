;;; Xdaemon --- Bash scripts to run X server as a daemon and to kill it

;; Copyright © 2016 Alex Kost <alezost@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a GNU Guix development package for Xdaemon.  To build, run:
;;
;;   guix build -f guix.scm

;;; Code:

(use-modules
 (guix packages)
 (guix git-download)
 (guix licenses)
 (guix build-system gnu)
 (gnu packages autotools)
 (gnu packages bash)
 (gnu packages xorg))

(define xdaemon-devel
  (let ((commit "5cfc7925b051c6e0c5255f30934d8bb540c4edc3"))
    (package
      (name "xdaemon")
      (version (string-append "0.1-1." (string-take commit 7)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "git://github.com/alezost/xdaemon.git")
                      (commit commit)))
                (file-name (string-append name "-" version "-checkout"))
                (sha256
                 (base32
                  "14qxips7rw3y0b6rlw4ixlk1djkz26ngd87fjb8xfl04gqnd7mdi"))))
      (build-system gnu-build-system)
      (arguments
       '(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'autogen
             (lambda _ (zero? (system* "sh" "autogen.sh")))))))
      (native-inputs
       `(("autoconf" ,autoconf)
         ("automake" ,automake)))
      (inputs
       `(("bash" ,bash)
         ("xorg-server" ,xorg-server)))
      (home-page "https://github.com/alezost/xdaemon")
      (synopsis "Run X server as a daemon")
      (description
       "Xdaemon is a wrapper bash script that allows to turn X server
into a daemon.  When Xdaemon is started, it runs Xorg server, then waits
until it will be ready to accept connections from clients, and quits.
Another script that comes with this package is Xkill.  It allows a user
to kill an X server running on a particular @code{DISPLAY}.")
      ;; 'Xdaemon' script is under FreeBSD, the rest is under GPL3 or later.
      (license (list bsd-2 gpl3+)))))

xdaemon-devel
