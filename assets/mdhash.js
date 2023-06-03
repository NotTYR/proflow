function mdhash(i, Y, W, U) {
    function K(b, a) {
        return (b << a) | (b >>> (32 - a))
    }

    function J(k, b) {
        var F, a, d, x, c;
        d = (k & 2147483648);
        x = (b & 2147483648);
        F = (k & 1073741824);
        a = (b & 1073741824);
        c = (k & 1073741823) + (b & 1073741823);
        if (F & a) {
            return (c ^ 2147483648 ^ d ^ x)
        }
        if (F | a) {
            if (c & 1073741824) {
                return (c ^ 3221225472 ^ d ^ x)
            } else {
                return (c ^ 1073741824 ^ d ^ x)
            }
        } else {
            return (c ^ d ^ x)
        }
    }

    function s(a, c, b) {
        return (a & c) | ((~a) & b)
    }

    function r(a, c, b) {
        return (a & b) | (c & (~b))
    }

    function q(a, c, b) {
        return (a ^ c ^ b)
    }

    function o(a, c, b) {
        return (c ^ (a | (~b)))
    }

    function u(G, F, ac, ab, k, H, I) {
        G = J(G, J(J(s(F, ac, ab), k), I));
        return J(K(G, H), F)
    }

    function f(G, F, ac, ab, k, H, I) {
        G = J(G, J(J(r(F, ac, ab), k), I));
        return J(K(G, H), F)
    }

    function D(G, F, ac, ab, k, H, I) {
        G = J(G, J(J(q(F, ac, ab), k), I));
        return J(K(G, H), F)
    }

    function t(G, F, ac, ab, k, H, I) {
        G = J(G, J(J(o(F, ac, ab), k), I));
        return J(K(G, H), F)
    }

    function e(F) {
        var G;
        var d = F.length;
        var c = d + 8;
        var b = (c - (c % 64)) / 64;
        var x = (b + 1) * 16;
        var H = Array(x - 1);
        var a = 0;
        var k = 0;
        while (k < d) {
            G = (k - (k % 4)) / 4;
            a = (k % 4) * 8;
            H[G] = (H[G] | (F.charCodeAt(k) << a));
            k++
        }
        G = (k - (k % 4)) / 4;
        a = (k % 4) * 8;
        H[G] = H[G] | (128 << a);
        H[x - 2] = d << 3;
        H[x - 1] = d >>> 29;
        return H
    }

    function B(c) {
        var b = "",
            d = "",
            k, a;
        for (a = 0; a <= 3; a++) {
            k = (c >>> (a * 8)) & 255;
            d = "0" + k.toString(16);
            b = b + d.substr(d.length - 2, 2)
        }
        return b
    }
    var C = Array();
    var O, h, E, v, g, aa, Z, X, V;
    var R = Y,
        P = 12,
        M = 17,
        L = 22;
    var A = W,
        z = 9,
        y = 14,
        w = 20;
    var p = 4,
        n = 11,
        m = 16,
        l = 23;
    var T = 6,
        S = 10,
        Q = 15,
        N = 21;
    C = e(i);
    aa = 1732584193;
    Z = 4023233417;
    X = 2562383102;
    V = U;
    for (O = 0; O < C.length; O += 16) {
        h = aa;
        E = Z;
        v = X;
        g = V;
        aa = u(aa, Z, X, V, C[O + 0], R, 3614090360);
        V = u(V, aa, Z, X, C[O + 1], P, 3905402710);
        X = u(X, V, aa, Z, C[O + 2], M, 606105819);
        Z = u(Z, X, V, aa, C[O + 3], L, 3250441966);
        aa = u(aa, Z, X, V, C[O + 4], R, 4118548399);
        V = u(V, aa, Z, X, C[O + 5], P, 1200080426);
        X = u(X, V, aa, Z, C[O + 6], M, 2821735955);
        Z = u(Z, X, V, aa, C[O + 7], L, 4249261313);
        aa = u(aa, Z, X, V, C[O + 8], R, 1770035416);
        V = u(V, aa, Z, X, C[O + 9], P, 2336552879);
        X = u(X, V, aa, Z, C[O + 10], M, 4294925233);
        Z = u(Z, X, V, aa, C[O + 11], L, 2304563134);
        aa = u(aa, Z, X, V, C[O + 12], R, 1804603682);
        V = u(V, aa, Z, X, C[O + 13], P, 4254626195);
        X = u(X, V, aa, Z, C[O + 14], M, 2792965006);
        Z = u(Z, X, V, aa, C[O + 15], L, 1236535329);
        aa = f(aa, Z, X, V, C[O + 1], A, 4129170786);
        V = f(V, aa, Z, X, C[O + 6], z, 3225465664);
        X = f(X, V, aa, Z, C[O + 11], y, 643717713);
        Z = f(Z, X, V, aa, C[O + 0], w, 3921069994);
        aa = f(aa, Z, X, V, C[O + 5], A, 3593408605);
        V = f(V, aa, Z, X, C[O + 10], z, 38016083);
        X = f(X, V, aa, Z, C[O + 15], y, 3634488961);
        Z = f(Z, X, V, aa, C[O + 4], w, 3889429448);
        aa = f(aa, Z, X, V, C[O + 9], A, 568446438);
        V = f(V, aa, Z, X, C[O + 14], z, 3275163606);
        X = f(X, V, aa, Z, C[O + 3], y, 4107603335);
        Z = f(Z, X, V, aa, C[O + 8], w, 1163531501);
        aa = f(aa, Z, X, V, C[O + 13], A, 2850285829);
        V = f(V, aa, Z, X, C[O + 2], z, 4243563512);
        X = f(X, V, aa, Z, C[O + 7], y, 1735328473);
        Z = f(Z, X, V, aa, C[O + 12], w, 2368359562);
        aa = D(aa, Z, X, V, C[O + 5], p, 4294588738);
        V = D(V, aa, Z, X, C[O + 8], n, 2272392833);
        X = D(X, V, aa, Z, C[O + 11], m, 1839030562);
        Z = D(Z, X, V, aa, C[O + 14], l, 4259657740);
        aa = D(aa, Z, X, V, C[O + 1], p, 2763975236);
        V = D(V, aa, Z, X, C[O + 4], n, 1272893353);
        X = D(X, V, aa, Z, C[O + 7], m, 4139469664);
        Z = D(Z, X, V, aa, C[O + 10], l, 3200236656);
        aa = D(aa, Z, X, V, C[O + 13], p, 681279174);
        V = D(V, aa, Z, X, C[O + 0], n, 3936430074);
        X = D(X, V, aa, Z, C[O + 3], m, 3572445317);
        Z = D(Z, X, V, aa, C[O + 6], l, 76029189);
        aa = D(aa, Z, X, V, C[O + 9], p, 3654602809);
        V = D(V, aa, Z, X, C[O + 12], n, 3873151461);
        X = D(X, V, aa, Z, C[O + 15], m, 530742520);
        Z = D(Z, X, V, aa, C[O + 2], l, 3299628645);
        aa = t(aa, Z, X, V, C[O + 0], T, 4096336452);
        V = t(V, aa, Z, X, C[O + 7], S, 1126891415);
        X = t(X, V, aa, Z, C[O + 14], Q, 2878612391);
        Z = t(Z, X, V, aa, C[O + 5], N, 4237533241);
        aa = t(aa, Z, X, V, C[O + 12], T, 1700485571);
        V = t(V, aa, Z, X, C[O + 3], S, 2399980690);
        X = t(X, V, aa, Z, C[O + 10], Q, 4293915773);
        Z = t(Z, X, V, aa, C[O + 1], N, 2240044497);
        aa = t(aa, Z, X, V, C[O + 8], T, 1873313359);
        V = t(V, aa, Z, X, C[O + 15], S, 4264355552);
        X = t(X, V, aa, Z, C[O + 6], Q, 2734768916);
        Z = t(Z, X, V, aa, C[O + 13], N, 1309151649);
        aa = t(aa, Z, X, V, C[O + 4], T, 4149444226);
        V = t(V, aa, Z, X, C[O + 11], S, 3174756917);
        X = t(X, V, aa, Z, C[O + 2], Q, 718787259);
        Z = t(Z, X, V, aa, C[O + 9], N, 3951481745);
        aa = J(aa, h);
        Z = J(Z, E);
        X = J(X, v);
        V = J(V, g)
    }
    var j = B(aa) + B(Z) + B(X) + B(V);
    return j.toLowerCase()
}