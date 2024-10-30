import 'dart:convert';

import 'package:payapp/core/components/print_text.dart';

class Php {
  /*
  * Translation to Dart of Nicolas Chambrier's JS implementation for unserializing PHP strings.
  * Based on https://github.com/naholyr/js-php-unserialize/blob/master/php-unserialize.js
  * */
  static Map<String, dynamic> unserialize(String data) {
    int utf8Overhead(String chr) {
      var code = chr.codeUnitAt(0);
      if (code < 0x0080) return 0;    // 1 byte
      if (code < 0x0800) return 1;    // 2 bytes
      return 2;                        // 3 bytes
    }

    void error(String type, String msg, [String filename = "n/a", String line = "n/a"]) {
      printThis("Error: $msg");
      printThis("- File: $filename");
      printThis("- Line: $line");
    }

    List<dynamic> readUntil(String data, int offset, String stopchr) {
      var buf = [];
      String chr;
      int i = 0;

      while (true) {
        chr = data.substring(offset + i, offset + i + 1);
        if (chr == stopchr) break;
        if ((i + offset) >= data.length) {
          error('Error', 'Invalid');
          break;
        }
        buf.add(chr);
        i++;
      }
      return [buf.length, buf.join('')];
    }

    List<dynamic> readChrs(String data, int offset, int length) {
      var buf = [];
      for (var i = 0; i < length; i++) {
        var chr = data.substring(offset + i, offset + i + 1);
        buf.add(chr);
        length -= utf8Overhead(chr);
      }
      return [buf.length, buf.join('')];
    }

    dynamic unserializeData(String data, int offset) {
      var dtype, dataoffset, keyandchrs, keys,
          readdata, readData, ccount, stringlength,
          i, key, kprops, kchrs, vprops, vchrs, value,
          chrs = 0,
          typeconvert = (dynamic x) => x;

      void readArray() {
        readdata = <String, dynamic>{};
        keyandchrs = readUntil(data, dataoffset, ':');
        chrs = keyandchrs[0];
        keys = keyandchrs[1];
        dataoffset += chrs + 2;

        int forVal = (keys is int) ? keys : int.parse(keys);
        for (i = 0; i < forVal; i++) {
          kprops = unserializeData(data, dataoffset);
          kchrs = kprops[1];
          key = kprops[2];
          dataoffset += kchrs;

          vprops = unserializeData(data, dataoffset);
          vchrs = vprops[1];
          value = vprops[2];
          dataoffset += vchrs;

          readdata[key] = value;
        }
      }

      offset ??= 0;
      dtype = data.substring(offset, offset + 1).toLowerCase();
      dataoffset = offset + 2;

      switch (dtype) {
        case 'i':
          typeconvert = (x) => (x is int) ? x : int.parse(x);
          readData = readUntil(data, dataoffset, ';');
          chrs = readData[0];
          readdata = readData[1];
          dataoffset += chrs + 1;
          break;

        case 'b':
          typeconvert = (x) => ((x is int) ? x : int.parse(x)) != 0;
          readData = readUntil(data, dataoffset, ';');
          chrs = readData[0];
          readdata = readData[1];
          dataoffset += chrs + 1;
          break;

        case 'd':
          typeconvert = (x) => (x is double) ? x : double.parse(x);
          readData = readUntil(data, dataoffset, ';');
          chrs = readData[0];
          readdata = readData[1];
          dataoffset += chrs + 1;
          break;

        case 'n':
          readdata = null;
          break;

        case 's':
          ccount = readUntil(data, dataoffset, ':');
          chrs = ccount[0];
          stringlength = ccount[1];
          dataoffset += chrs + 2;

          readData = readChrs(data, dataoffset, int.parse(stringlength));
          chrs = readData[0];
          readdata = readData[1];
          dataoffset += chrs + 2;

          if (chrs != int.parse(stringlength) && chrs != readdata.length) {
            error('SyntaxError', 'String length mismatch');
          }
          break;

        case 'a':
          readArray();
          dataoffset += 1;
          break;

        case 'o':
          ccount = readUntil(data, dataoffset, ':');
          dataoffset += ccount[0] + 2; // move past count

          ccount = readUntil(data, dataoffset, '"');
          dataoffset += ccount[0] + 2; // move past class name

          readArray();
          dataoffset += 1;
          break;

        default:
          error('SyntaxError', 'Unknown / Unhandled data type(s): ' + dtype);
          break;
      }
      return [dtype, dataoffset - offset, typeconvert(readdata)];
    }

    return jsonDecode(unserializeData(data + '', 0)[2].toString());
  }
}
