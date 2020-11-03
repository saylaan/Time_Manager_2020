module.exports = {
    getCookie(cname) {
        var name = cname + "=";
        var decodedCookie = decodeURIComponent(document.cookie);
        var ca = decodedCookie.split(";");
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) === " ") {
                c = c.substring(1);
            }
            if (c.indexOf(name) === 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    },
    checkCookie(name) {
        const username = this.getCookie(name);
        if (username !== "") {
            return true;
        } else {
            return false;
        }
    },
    delay(time, callback) {
        setInterval(callback, time * 1000);
    }
    // Swal.fire({
    //     position: "top-end",
    //     type: "success",
    //     title: "You sign in Google with username : ",
    //     text: jwtUser.user.username,
    //     showConfirmButton: false,
    //     timer: 2000
    // });
}