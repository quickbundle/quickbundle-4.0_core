package org.quickbundle.tools.helper;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.regex.Pattern;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.SAXReader;
import org.quickbundle.project.init.RmConfig;
import org.quickbundle.tools.support.cn2spell.Cn2Spell;
import org.quickbundle.tools.support.log.RmLogHelper;
import org.quickbundle.tools.support.unicode.UnicodeReader;
import org.quickbundle.util.RmString;

/**
 * 功能、用途、现存BUG: 帮助实现一些通用的字符串处理
 * 
 * @author
 * @version 1.0.0
 * @see 需要参见的其它类
 * @since 1.0.0
 */
public class RmStringHelper {

	/**
	 * 将字符串以指定字符串切割后,分配到List中
	 * 
     * @param strValue-->输入字符串
	 * @return List
	 */
	public static List<String> getTokenizerList(String strValue, String delim) {
		List<String> myList = new ArrayList<String>();
		StringTokenizer stChat = new StringTokenizer(strValue, delim);
		int iLength = stChat.countTokens();
		for (int i = 0; i < iLength; i++) {
			String strTemp = stChat.nextToken();
			if (strTemp == null)
				strTemp = "";
			myList.add(strTemp);
		}
		return myList;
	}

	/**
	 * 将Object[]中的对象的字符串，以逗号分割后拼成一个字符串,不带有单引号
	 * 
     * @param strArray 输入字符串数组
	 * @return String
	 */
    public static String parseToSQLString(Object[] strArray) {
        if (strArray == null || strArray.length == 0) {
			return "-1"; //为了让长度为0的数组返回的sql不报错
        }
		StringBuilder sb = new StringBuilder();
        for (int i = 0; i < strArray.length - 1; i++) {
        	if(strArray[i] != null) {
            	sb.append(strArray[i]);
            	sb.append(",");
        	}
		}
        if(strArray[strArray.length - 1] != null) {
        	sb.append(strArray[strArray.length - 1]);        	
        }
        if(sb.toString().trim().length() == 0) {
        	return "-1";
        }
        return sb.toString();
	}

	/**
	 * 将Object[]中的对象的字符串，以以逗号分割后拼成一个字符串,带有单引号
	 * 
     * @param strArray 输入字符串数组
	 * @return String
	 */
	public static String parseToSQLStringApos(Object[] strArray) {
		if (strArray == null || strArray.length == 0) {
			return "'-1'"; //为了让长度为0的数组返回的sql不报错
		}
		StringBuilder sb = new StringBuilder();
        for (int i = 0; i < strArray.length - 1; i++) {
        	if(strArray[i] != null) {
            	sb.append("'");
            	sb.append(strArray[i].toString());
            	sb.append("',");
        	}
		}
        if(strArray[strArray.length - 1] != null) {
        	sb.append("'");
        	sb.append(strArray[strArray.length - 1].toString());
        	sb.append("'");
        }
        return sb.toString();
	}

	/**
	 * 功能: 把"123,234,567"转为new String[]{"123", "234", "567"}
	 * 
	 * @param str
	 * @return
	 */
	public static String[] parseStringToArray(String str) {
		return parseStringToArray(str, ",");
	}

	/**
	 * 功能: 把"123,234,567"转为new String[]{"123", "234", "567"}
	 * 
	 * @param str
	 * @param splitKey
	 * @return
	 */
	public static String[] parseStringToArray(String str, String splitKey) {
		String[] returnStrArray = null;
		if (str != null && str.length() > 0) {
			returnStrArray = str.split(splitKey, -1);
		}
		if (returnStrArray == null) {
			returnStrArray = new String[0];
		}
		return returnStrArray;
	}

	/**
	 * 将String[]中字符串以","分割后拼成一个字符串
	 * 
     * @param strArray-->输入字符串数组
	 * @return String
	 */
	public static String parseToString(String[] strArray) {
		if (strArray == null || strArray.length == 0) {
			return "";
		} else if (strArray.length == 1) {
			return strArray[0];
		}

		return parseToSQLString(strArray);
	}

	/**
	 * 将ISO字符串转换为GBK编码的字符串。
	 * 
     * @param str-->输入字符串
	 * @return 经编码后的字符串，如果有异常，则返回原编码字符串
	 */
	public static String iso2Gbk(String original) {
		if (original != null) {
			try {
				return new String(original.getBytes("iso8859-1"), "gbk");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
				return null;
			}
		}
		return null;
	}

	/**
	 * 将iso-8859-1字符串转换为UTF-8编码的字符串。
	 * 
     * @param original-->输入字符串
	 * @return 经编码后的字符串，如果有异常，则返回原编码字符串
	 */
	public static String iso2Utf8(String original) {
		if (original != null) {

			try {
				return new String(original.getBytes("iso8859-1"), "utf-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
				return null;
			}
		}
		return null;
	}

	/**
	 * 功能: 把指定字符串original 从encode1 转化到encode2
	 * 
	 * @param original
	 * @param encode1
	 * @param encode2
	 * @return
	 */
	public static String encode2Encode(String original, String encode1,
			String encode2) {
		if (original != null) {
			try {
				return new String(original.getBytes(encode1), encode2);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
				return null;
			}
		}
		return null;
	}

	/**
	 * 功能: 以encode1的编码方式获得original
	 * 
	 * @param original
	 * @param encode1
	 * @return
	 */
	public static String getStringByEncode(String original, String encode1) {
		if (original != null) {
			try {
				return new String(original.getBytes(), encode1);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
				return null;
			}
		}
		return null;
	}

	/**
	 * 把指定字符串strSource 中的strFrom 全部替换为strTo,不是正则表达式
	 * 
	 * @param strSource
	 * @param strFrom
	 * @param strTo
	 * @return
	 */
    public static String replaceAll(String strSource, String strFrom, String strTo) {
    	if(strSource == null) {
    		return null;
    	}
    	if(strFrom == null || strFrom.length() == 0 || strTo == null) {
    		return strSource;
    	}
		StringBuilder sbDest = new StringBuilder();
		int intPos;
		while ((intPos = strSource.indexOf(strFrom)) > -1) {
			sbDest.append(strSource.substring(0, intPos));
			sbDest.append(strTo);
			strSource = strSource.substring(intPos + strFrom.length());
		}
		sbDest.append(strSource);
		return sbDest.toString();
	}

	/**
	 * 把strSource中的第1个strFrom替换为strTo
	 * @deprecated 弃用
	 * 
	 * @param strSource
	 * @param strFrom
	 * @param strTo
	 * @return
	 */
    static String replaceFirst_(String strSource, String strFrom, String strTo) {
		StringBuilder strDest = new StringBuilder();
		int intFromLen = strFrom.length();
		int intPos;
		while ((intPos = strSource.indexOf(strFrom)) != -1) {
			strDest.append(strSource.substring(0, intPos));
			strDest.append(strTo);
			strSource = strSource.substring(intPos + intFromLen);
			break;
		}
		strDest.append(strSource);
		return strDest.toString();
	}

	/**
	 * 把str中的第1个sequence1替换为sequence2
	 * 
	 * @param str
	 * @param sequence1	the old character sequence
	 * @param sequence2	the new character sequence
	 * @return
	 */
	public static String replaceFirst(String str, CharSequence sequence1, CharSequence sequence2) {
		if (sequence2 == null)
			throw new NullPointerException();
		int sequence1Length = sequence1.length();
		if (sequence1Length == 0) {
			StringBuilder result = new StringBuilder(str.length() + sequence2.length());
			result.append(sequence2);
			result.append(str);
			return result.toString();
		}
		StringBuilder result = new StringBuilder();
		char first = sequence1.charAt(0);
		int start = 0, copyStart = 0, firstIndex;
		while (start < str.length()) {
			if ((firstIndex = str.indexOf(first, start)) == -1)
				break;
			boolean found = true;
			if (sequence1.length() > 1) {
				if (firstIndex + sequence1Length > str.length())
					break;
				for (int i=1; i<sequence1Length; i++) {
					if (str.charAt(firstIndex + i) != sequence1.charAt(i)) {
						found = false;
						break;
					}
				}
			}
			if (found) {
				result.append(str.substring(copyStart, firstIndex));
				result.append(sequence2);
				copyStart = start = firstIndex + sequence1Length;
				break; //只发现一次就退出
			} else {
				start = firstIndex + 1;
			}
		}
		if (result.length() == 0 && copyStart == 0)
			return str;
		result.append(str.substring(copyStart));
		return result.toString();
	}

	/**
	 * 对regix转义成字符串
	 * @param s
	 * @return
	 */
	//TODO 扩展为对所有regex关键字的支持
	public static String replaceAll4RegexEscape(String s) {
		return s.replaceAll("([\\$])", "\\\\$1");
	}

	/**
	 * 功能: 过滤Html页面中的敏感字符,用于在script脚本中显示
	 * 
	 * @param value
	 * @return
	 */
	public static String replaceStringToScript(Object obj) {
		return replaceStringToScript(obj == null ? "" : obj.toString());
	}

	/**
	 * 功能: 过滤Html页面中的敏感字符,用于在script脚本中显示
	 * 
	 * @param value
	 * @return
	 */
	public static String replaceStringToScript(String value) {
		return replaceStringByRule(value, new String[][] { 
				{ "'", "\\'" },{ "\"", "\\\"" }, { "\\", "\\\\" }, { "\r", "\\r" },
				{ "\n", "\\n" }, { "\t", "\\t" }, { "\f", "\\f" }, { "\b", "\\b" } 
			});
	}
	
    /**
     * 对象
     * 
     * @param tempValue
     * @return
     */
    public static String parseToJsValue(Object tempValue) {
    	if(tempValue == null) {
    		return null;
    	}
    	StringBuilder sb = new StringBuilder();
        if (tempValue instanceof String || tempValue instanceof Integer || tempValue instanceof Long) { //如果是String、int、 long单值
        	sb.append("\"");
        	sb.append(replaceStringToScript(tempValue.toString())); //从数据库中取出来以后需要转换1次
        	sb.append("\"");
        } else if (tempValue instanceof BigDecimal) { //如果是数字，直接注入
        	sb.append("\"");
            BigDecimal tmpB = new BigDecimal(tempValue.toString()).setScale(RmConfig.defaultNumberScale(), BigDecimal.ROUND_HALF_UP);
            sb.append(replaceStringToScript(tmpB.toString()));
            sb.append("\"");
        } else if (tempValue instanceof String[] || tempValue instanceof int[] || tempValue instanceof long[]) { //如果是多值，放入数组
        	sb.append("[");
            String[] myArray = (String[]) tempValue;
            for (int i = 0; i < myArray.length; i++) {
                if (i > 0) {
                	sb.append(", ");
                }
                sb.append("\"");
                sb.append(replaceStringToScript(myArray[i]));
                sb.append("\"");
            }
            sb.append("]");
        } else if (tempValue instanceof Timestamp) { //如果是时间戳
        	sb.append("\"");
        	String str = tempValue.toString().substring(0,19);
        	if(" 00:00:00".equals(str.substring(10))) {
        		sb.append(replaceStringToScript(str.substring(0, 10)));
        	} else {
        		sb.append(replaceStringToScript(str));
        	}
        	sb.append("\"");
        }  else if (tempValue instanceof Date) { //如果是日期戳
        	sb.append("\"");
        	sb.append(replaceStringToScript(tempValue.toString().substring(0,10)));
        	sb.append("\"");
        } else if(tempValue instanceof Map || tempValue instanceof Collection) { //跳过Map
            return null;
        } else {
            RmLogHelper.warn(RmStringHelper.class, "从Object转化为js，遇到了未知java类型:" + tempValue);                    
            return null;
        }
        return sb.toString();
    }

	/**
	 * 过滤Html页面中的敏感字符
	 * 
	 * @param value
	 * @return
	 */
	public static String replaceStringToHtml(Object obj) {
		return replaceStringToHtml(obj == null ? "" : obj.toString());
	}

	/**
	 * 过滤Html页面中的敏感字符
	 * 
	 * @param value
	 * @return
	 */
	public static String replaceStringToHtml(String value) {
		return replaceStringByRule(value, new String[][] { { "<", "&lt;" },
				{ ">", "&gt;" }, { "&", "&amp;" }, { "\"", "&quot;" },
				{ "'", "&#39;" }, { "\n", "<BR>" }, { "\r", "<BR>" } });
	}

	/**
	 * 把<替换成&lt;，应对编辑html代码
	 * 
	 * @param value
	 * @return
	 */
	public static String replaceStringToEditHtml(String value) {
		if (value == null) {
			value = "";
		}
		return replaceStringByRule(value, new String[][] { { "<", "&lt;" } });
	}

	/**
	 * 过滤Html页面中的敏感字符，接受过滤的字符列表和转化后的值
	 * 
	 * @param value
	 * @return
	 */
	public static String replaceStringByRule(String value, String[][] aString) {
		if (value == null) {
			return ("");
		}
		char content[] = new char[value.length()];
		value.getChars(0, value.length(), content, 0);
		StringBuffer result = new StringBuffer(content.length + 50);

		for (int i = 0; i < content.length; i++) {
			boolean isTransct = false;
			for (int j = 0; j < aString.length; j++) {
				if (String.valueOf(content[i]).equals(aString[j][0])) {
					result.append(aString[j][1]);
					isTransct = true;
					break;
				}
			}
			if (!isTransct) {
				result.append(content[i]);
			}
		}
		return result.toString();
	}

	/**
	 * 显示数据前过滤掉null
	 * 
	 * @param myString
	 * @return
	 */
	public static String prt(String myString) {
		if (myString != null) {
			return myString;
		} else {
			return "";
		}
	}

	public static String prt(Object obj) {
		if (obj != null) {
			return prt(obj.toString());
		} else {
			return "";
		}
	}

	/**
	 * 显示数据前过滤掉null，截取一定位数
	 * 
	 * @param myString
	 * @param index
	 *            最大显示的长度
	 * @return
	 */
	public static String prt(String myString, int index) {
		if (myString != null) {
			if (myString.length() >= index) {
				return myString.substring(0, index);
			} else {
				return myString;
			}
		} else {
			return "";
		}
	}

	public static String prt(Object obj, int index) {
		if (obj != null) {
			return prt(obj.toString(), index);
		} else {
			return "";
		}
	}

	/**
	 * 显示数据前过滤掉null，截取一定位数，并加上表示，如省略号
	 * 
	 * @param myString
	 * @param index
	 *            最大显示的长度
	 * @return
	 */
	public static String prt(String myString, int index, String accessional) {
		int accessionalLength = 0;
		if (index < 0) {
			return myString;
		}
		if (accessional == null || "".equals(accessional)) {
			accessional = "...";
		}
		accessionalLength = accessional.length();
		if (myString != null) {
			if (index <= accessionalLength) {
				return myString.substring(0, index);
			} else if (myString.length() >= index - accessionalLength) {
				return myString.substring(0, index - accessionalLength)
						+ accessional;
			} else {
				return myString;
			}
		} else {
			return "";
		}
	}

	public static String prt(Object obj, int index, String accessional) {
		if (obj != null)
			return prt(obj.toString(), index, accessional);
		else {
			return "";
		}
	}

	/**
	 * 判断一个数组是否包含一个字符串
	 * 
	 * @param arrayString
	 * @param str
	 * @return
	 */
	public static boolean arrayContainString(String[] arrayString, String str) {
		if (arrayString == null || arrayString.length == 0) {
			return false;
		}
		for (int i = 0; i < arrayString.length; i++) {
			if (arrayString[i].equals(str))
				return true;
		}
		return false;
	}

	/**
	 * 功能: 把new String[]{"abc", null, "123"}转化为 "abc,123"
	 * 
	 * @param arrayString
	 * @param splitStr
	 * @return
	 */
	public static String arrayToString(String[] arrayString, String splitStr) {
		StringBuilder sb = new StringBuilder();
		if (arrayString == null || arrayString.length == 0) {
			return null;
		}
		for (int i = 0; i < arrayString.length; i++) {
			if (arrayString[i] != null && arrayString[i].length() > 0) {
				if (sb.length() > 0) {
					sb.append(splitStr);
				}
				sb.append(arrayString[i]);
			}
		}
		return sb.toString();
	}

	/**
	 * 功能: 测试各种编码之间的转化，找出乱码原因
	 * 
	 * @param original
	 * @return
	 */
	public static String testAllEncode(String original) {
        return testAllEncode(original, new String[] { "GBK", "iso8859-1", "gb2312", "UTF-8" });
	}

	/**
	 * 功能: 测试各种编码之间的转化，找出乱码原因
	 * 
	 * @param original
	 * @param encode
	 * @return
	 */
	public static String testAllEncode(String original, String[] encode) {
		StringBuilder rtValue = new StringBuilder();
		rtValue.append("original = ");
		rtValue.append(original);
		rtValue.append("\n");
		if (encode == null || encode.length < 2) {
			return rtValue.toString();
		}
		for (int i = 0; i < encode.length; i++) {
			rtValue.append("\n");
			rtValue.append(encode[i]);
			rtValue.append("-->\n");
			for (int j = 0; j < encode.length; j++) {
				rtValue.append(encode[i]);
				rtValue.append("-->");
				rtValue.append(encode[j]);
				rtValue.append(" = ");
				rtValue.append(encode2Encode(original, encode[i], encode[j]));
				rtValue.append("\n");
			}
		}
		return rtValue.toString();
	}

	/**
	 * 功能: 对url编码
	 * 
	 * @param url
	 * @return
	 */
	public static String encodeUrl(String url) {
		String rtStr = "";
		try {
			if (url != null && url.length() >= 0) {
				rtStr = URLEncoder.encode(url, RmConfig.defaultEncode());
			}
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e);
		}
		return rtStr;
	}

	public static String decodeUrl(String url) {
		String rtStr = "";
		try {
			if (url != null && url.length() >= 0) {
				rtStr = URLDecoder.decode(url, RmConfig.defaultEncode());
			}
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e);
		}
		return rtStr;
	}

	/**
	 * 功能: 把Map中的值依次取出来，以URL传值的方式拼成字符串
	 * 
	 * @param mValue
	 * @return
	 */
	public static String encodeUrlParameter(Map<String, Object> mValue) {
		return encodeUrlParameter(mValue, new String[0]);
	}

	/**
	 * 功能: 把Map中的值依次取出来，以URL传值的方式拼成字符串
	 * 
	 * @param mValue
     * @param ignoreName 忽略的field
	 * @return
	 */
    public static String encodeUrlParameter(Map<String, Object> mValue, String[] ignoreName) {
		StringBuilder str = new StringBuilder();
        for(Iterator itMValue = mValue.keySet().iterator(); itMValue.hasNext(); ) {
			String tempKey = String.valueOf(itMValue.next());
            String tempValue = (mValue.get(tempKey) == null) ? "" : String.valueOf(mValue.get(tempKey));
			if (tempKey.startsWith("RM") || tempKey.startsWith("RANMIN")) {
				// TODO
                if(!tempKey.equals(RmConfig.PageKey.RM_PAGE_SIZE.key())&&!tempKey.equals(RmConfig.PageKey.RM_CURRENT_PAGE.key())&& !tempKey.equals(RmConfig.PageKey.RM_ORDER_STR.key())){
					continue;
				}
			}
            if (RmStringHelper.arrayContainString(ignoreName, tempKey)) {
				continue;
			}
			if (str.length() > 0) {
				str.append("&");
			}
			str.append(tempKey);
			str.append("=");
			str.append(encodeUrl(tempValue));
		}
		return str.toString();
	}

	/**
	 * 功能: 从一个文件中读出字符串
	 * 
	 * @param file
	 * @return
	 * @throws IOException
	 */
	public static String readStringFromFile(File file, String encode) {
		StringBuilder sb = new StringBuilder();
		BufferedReader in;
		try {
            in = new BufferedReader(new UnicodeReader(new FileInputStream(file), encode));
			boolean isFirstLine = true;
			String tempStr = "";
			while ((tempStr = in.readLine()) != null) {
				if (isFirstLine) {
					isFirstLine = false;
				} else {
					sb.append("\n");
				}
				sb.append(tempStr);
			}
			in.close();
		} catch (FileNotFoundException e) {
			throw new RuntimeException("readStringFromFile error", e);
		} catch (IOException e) {
			throw new RuntimeException("readStringFromFile error", e);
		}
		return sb.toString();
	}

	/**
	 * 功能: 写一个字符串到文件中去
	 * 
	 * @param str
	 * @param file
	 */
	public static File writeStringToFile(String str, File file) {
		try {
			BufferedReader in4 = new BufferedReader(new StringReader(str));
            PrintWriter out1 = new PrintWriter(new BufferedWriter(new FileWriter(file)));
			String tempStr = null;
			while ((tempStr = in4.readLine()) != null) {
				out1.println(tempStr);
			}
			out1.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return file;
	}

	public static String fileToString(File file) throws IOException {
		StringBuilder str = new StringBuilder();
		long totalSize = 0;
		str.append("卷（");
		str.append(file.toString());
		str.append("）的文件夹 PATH 列表\n");
		str.append("卷信息\t");
		str.append(" 存在:");
		str.append(file.exists());
		str.append("  是文件夹:");
		str.append(file.isDirectory());
		str.append("  能读:");
		str.append(file.canRead());
		str.append("  能写:");
		str.append(file.canWrite());
		str.append("  是否隐藏:");
		str.append(file.isHidden());
		str.append("  最后修改时间:");
		str.append(getFormatDateTimeDesc(file.lastModified()));
		str.append("\n");
		str.append(file.getAbsoluteFile());
		str.append("\n");
		RmString rmstr = listFileRecursive(file, "│├─", totalSize);
		str.append(rmstr.toString());
		str.append("\n总大小:");
		str.append(((Long)rmstr.getAttribute("totalSize")).longValue() / 1024);
		str.append(" k, ");
		str.append(((Long)rmstr.getAttribute("totalSize")).longValue());
		str.append("B.");
		return str.toString();
	}

    private static RmString listFileRecursive(File file, String sign, long totalSize) throws IOException {
		RmString rmstr = new RmString();
		if (rmstr.getAttribute("totalSize") == null) {
			rmstr.addAttribute("totalSize", new Long(0));
		}
		StringBuilder str = new StringBuilder();
		File[] fileChild = file.listFiles();
		if (fileChild != null) {
			int fileSum = 0, folderSum = 0;
			{ // 计算文件和文件夹个数
				for (int i = 0; i < fileChild.length; i++) {
					if (fileChild[i].isFile()) {
						fileSum++;
					} else if (fileChild[i].isDirectory()) {
						folderSum++;
					}
				}
			}
			for (int i = 0; i < fileChild.length; i++) {
				if (fileChild[i].isFile()) {
					fileSum++;
					if (folderSum > 0) {
                        str.append(sign.replaceAll("│├─", "│  "));
                        str.append(fileChild[i].getName());
                        str.append("\n");
					} else {
						str.append(sign.replaceAll("│├─", "   "));
						str.append(fileChild[i].getName());
						str.append("\n");
					}
					{ // 计算大小
                        long currentSize = ((Long)rmstr.getAttribute("totalSize")).longValue() + fileChild[i].length();
						rmstr.addAttribute("totalSize", new Long(currentSize));
					}
				}
			}
			if (fileSum > 0 && folderSum > 0) {
				str.append(sign.replaceAll("│├─", "│  "));
				str.append("\n");
			}
			int tempFolderIndex = 0;
			for (int i = 0; i < fileChild.length; i++) {
				if (fileChild[i].isDirectory()) {
					RmString tempRmstr = null;
					if (tempFolderIndex == folderSum - 1) {
						str.append(sign.replaceAll("│├─", "└──"));
						str.append(fileChild[i].getName());
						str.append("\n");
                        tempRmstr = listFileRecursive(fileChild[i], (sign + "   ").replaceAll("│├─   ", "   │├─"), totalSize);
					} else {
						str.append(sign.replaceAll("│├─", "├──"));
						str.append(fileChild[i].getName());
						str.append("\n");
                        tempRmstr = listFileRecursive(fileChild[i], (sign + "   ").replaceAll("│├─   ", "│  │├─"), totalSize);
					}
					{
                        long currentSize = ((Long)rmstr.getAttribute("totalSize")).longValue() + ((Long)tempRmstr.getAttribute("totalSize")).longValue();
						rmstr.addAttribute("totalSize", new Long(currentSize));
						str.append(tempRmstr);
					}
					tempFolderIndex++;
				}
			}
		}
		rmstr.setValue(str.toString());
		return rmstr;
	}

	/**
	 * 功能: 从ruleXml读取到Document
	 * 
	 * @param ruleXml
	 * @return
	 * @throws MalformedURLException
	 * @throws DocumentException
	 */
    public static Document parseXml(String ruleXml) throws MalformedURLException, DocumentException {
		if (ruleXml == null || ruleXml.length() == 0) {
			throw new NullPointerException("xml路径是空!");
		}
		SAXReader reader = new SAXReader();
		Document document = null;
		if (ruleXml.startsWith("file:")) {
			document = reader.read(new URL(ruleXml));
		} else if (ruleXml.startsWith("http://")) {
			document = reader.read(new URL(ruleXml));
		} else {
			document = reader.read(new File(ruleXml));
		}

		return document;
	}

	/**
	 * 功能: 得到str的首字母大写
	 * 
	 * @param str
	 * @return
	 */
	public static String toFirstUpperCase(String str) {
		if (str == null || str.length() == 0) {
			return str;
		} else {
			String firstStr = str.substring(0, 1);
			return firstStr.toUpperCase() + str.substring(1);
		}
	}

	/**
	 * 功能: 得到百分比的显示
	 * 
	 * @param numerator
	 * @param denominator
	 * @return
	 */
	public static String getPercentage(int numerator, int denominator) {
		return getPercentage(numerator * 1.00, denominator * 1.00);
	}

	/**
	 * 功能: 得到百分比的显示
	 * 
	 * @param numerator
	 * @param denominator
	 * @return
	 */
	public static String getPercentage(double numerator, double denominator) {
		double percentage = numerator * 1.00 / denominator;
		if (String.valueOf(percentage).endsWith(String.valueOf(Double.NaN))) {
			return "";
		}
		percentage = percentage * 100;
		NumberFormat nf = NumberFormat.getInstance();
		nf.setMaximumFractionDigits(2);
		return nf.format(percentage) + "%";
	}

	/**
	 * 功能:
	 * 
	 * @param value
	 * @param fractionDigits
	 * @return
	 */
	public static String defaultFormatDouble(BigDecimal value) {
		return defaultFormatDouble(value, 2);
	}
	/**
	 * 功能:
	 * 
	 * @param value
	 * @param fractionDigits
	 * @return
	 */
	public static String defaultFormatDouble(BigDecimal value, int fractionDigits) {
		if(value == null){
			return "";
		}
		
		return defaultFormatDouble(value.doubleValue(), fractionDigits);
	}
	/**
	 * 功能:
	 * 
	 * @param value
	 * @param fractionDigits
	 * @return
	 */
	public static String defaultFormatDouble(double value, int fractionDigits) {
		NumberFormat nf = NumberFormat.getInstance();
		nf.setGroupingUsed(false);
		nf.setMinimumFractionDigits(fractionDigits);
		nf.setMaximumFractionDigits(fractionDigits);
		return nf.format(value);
	}

	/**
	 * 功能: 把15位的身份证号码升级为18位
	 * 
	 * @param oldIdCard
	 * @return
	 */
	public static String updateIdCard(String oldIdCard) {
		String newIdCard = "";
		StringBuffer tempStrOld = new StringBuffer();
		tempStrOld.append(oldIdCard);
		int cOld[] = new int[17];
		int iSum = 0;
		oldIdCard = oldIdCard.substring(0,6) + "19" + oldIdCard.substring(6,oldIdCard.length());
		try {
			if (oldIdCard.length() != 17) {
				throw new Exception();
			}
			for (int i = 0; i < 17; i++) {
				cOld[i] = Integer.parseInt(String.valueOf(oldIdCard.charAt(i)));
			}
			int wi[] = new int[] { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8,
					4, 2 };
			iSum = 0;
			for (int i = 0; i < 17; i++) {
				iSum = iSum + cOld[i] * wi[i];
			}
		} catch (Exception e) {
			throw new RuntimeException("请输入正确格式的身份证号码!");
		}
		int y = iSum % 11;
		String strVer = new String("10X98765432");
		newIdCard = oldIdCard + strVer.substring(y, y + 1);
		return newIdCard;
	}

	/**
	 * 功能: 得到指定长度的int的字符串
	 * 
	 * @param myInt
	 * @param length
	 * @return
	 */
	public static String getFormatLengthInt(int myInt, int length) {
		String str = String.valueOf(myInt);
		if (str.length() < length) {
			int offLength = length - str.length();
			for (int j = 0; j < offLength; j++) {
				str = "0" + str;
			}
		}
		return str;
	}

	public static String getAvg(Object apprcount, Object submitcount) {

		float count = 0;
		float scount = 0;
		float avg = 0;

		if (!"".equals(apprcount) && apprcount != null) {
			count = new Float(apprcount.toString()).floatValue();
		}

		if (!"".equals(submitcount) && submitcount != null) {
			scount = new Float(submitcount.toString()).floatValue();
		}

		if (scount != 0) {
			avg = count / scount * 100;
		}
		return avg + "";
	}

    public static String getExcelResult(Object apprcount,Object submitcount,Object avg,Object totalAvg){

		float count = 0;
		float scount = 0;
		float result = 0;

		if (!"".equals(apprcount) && apprcount != null) {
			count = new Float(apprcount.toString()).floatValue();
		}

		if (!"".equals(submitcount) && submitcount != null) {
			scount = new Float(submitcount.toString()).floatValue();
		}

		if (scount != 0) {
			result = count / scount * 100;
		}

		float avgValue = 0;
		float totalAvgValue = 0;

		if (!"".equals(avg) && avg != null) {
			avgValue = new Float(avg.toString()).floatValue();
		}

		if (!"".equals(totalAvg) && totalAvg != null) {
			totalAvgValue = new Float(totalAvg.toString()).floatValue();
		}

		return result - 2 * avgValue + 2 * totalAvgValue + "";
	}

	public static String getSummitratio(String submitcount, String groupcount) {

		float submitcountValue = 0;
		float groupcountValue = 0;
		float summitratio = 0;

		if (!"".equals(submitcount) && submitcount != null) {
			submitcountValue = new Float(submitcount.toString()).floatValue();
		}

		if (!"".equals(groupcount) && groupcount != null) {
			groupcountValue = new Float(groupcount.toString()).floatValue();
		}

		if (groupcountValue != 0) {
			summitratio = submitcountValue / groupcountValue * 100;
		}
		return summitratio + "";
	}

	/**
	 * 得到Throwable的堆栈信息
	 * 
	 * @param t
     * @param rows 最长多少行
	 * @return
	 */
	public static String getStackTraceStr(Throwable t, int rows) {
		StringBuilder result = new StringBuilder();
		Throwable currentE = t;
		int count = 0;
		while(currentE != null) {
			if(currentE != t) {
				result.append("Caused by: ");
			}
			result.append(currentE.toString());
			result.append("\n");
			for (int i = 0; i < currentE.getStackTrace().length; i++) {
				count ++;
				if (rows > 0 && count > rows) {
					result.append("......\n");
					break;
				}
				result.append(currentE.getStackTrace()[i]);
				result.append("\n");
			}
			currentE = currentE.getCause();
		}
		return result.toString();
	}
	
	/**
	 * 得到调用栈信息
	 * @param rows 最长多少行
	 * @return
	 */
	public static String getStackTrace(int rows) {
		StringBuilder result = new StringBuilder();
		StackTraceElement[] sts = Thread.currentThread().getStackTrace();
    	for(int i=0; i<sts.length; i++) {
    		if(i == 0 
    				&& Thread.class.getName().equals(sts[i].getClassName()) 
    				&& "getStackTrace".equals(sts[i].getMethodName())) {
    			continue;
    		}
    		if(i == 1 
    				&& RmStringHelper.class.getName().equals(sts[i].getClassName()) 
    				&& "getStackTrace".equals(sts[i].getMethodName())) {
    			continue;
    		}
    		if(result.length() > 0) {
    			result.append("\n");
    		}
			if (rows > 0 && i > rows) {
				result.append("......");
				break;
			}
    		result.append(sts[i]);
    	}
    	return result.toString();
	}

	/**
	 * 功能:
	 * 
	 * @param str1
	 * @param str2
	 * @return
	 */
	public static String getOrOperator(String str1, String str2) {
		if (str1 == null || str2 == null) {
			return null;
		}
		if (str1.length() > str2.length()) {
			return getOrOperator(str2, str1);
		}
		StringBuilder str = new StringBuilder();
		for (int i = 0; i < str1.length(); i++) {
			if ("1".equals(str1.substring(i, i + 1)) || "1".equals(str2.substring(i, i + 1))) {
				str.append("1");
			} else {
				str.append("0");
			}
		}
		if (str2.length() > str1.length()) {
			str.append(str2.substring(str1.length(), str2.length()));
		}
		return str.toString();
	}


	/**
	 * 功能: 获得格式化的日期和时间描述
	 * 
     * @param longDate 时间的长整数
	 * @return YYYY-MM-DD HH24:MI:SS 格式的字符串
	 */
	public static String getFormatDateTimeDesc(long longDate) {
		return new Timestamp(longDate).toString().substring(0, 19);
	}

	/**
	 * 简单分析文件名后缀
	 * 
	 * @param str
	 * @return
	 */
	public static String getSuffix(String str) {
		if (str == null || str.length() == 0) {
			return "";
		}
		if (Pattern.compile("gif|jpg|png|xls|doc|docx|zip|rar|swf|txt", Pattern.CASE_INSENSITIVE).matcher(str.trim()).find()) {
			return str;
		} else {
			return "ot";
		}
	}

	/**
	 * 判断不为空null 和 “”
	 * 
	 * @param eStr
	 * @return
	 */
	public static boolean checkNotEmpty(String eStr) {
		if (eStr == null || "".equals(eStr)) {
			return false;
		}
		return true;
	}

	/**
	 * 判断为空
	 * 
	 * @param eStr
	 * @return
	 */
	public static boolean checkEmpty(String eStr) {
		if (eStr == null || "".equals(eStr)) {
			return true;
		}
		return false;
	}

	/**
	 * 字符串转成数组，并过滤空值
	 * 
	 * @param strs
	 * @return
	 */
	public static String[] strSplits(String strs, String eStr) {
		if (RmStringHelper.checkEmpty(strs)) {
			return null;
		}
		String[] str1s = strs.split(eStr);
		StringBuilder strAlls = new StringBuilder();
		for (int i = 0; i < str1s.length; i++) {
			if (RmStringHelper.checkNotEmpty(str1s[i])) {
				strAlls.append(str1s[i]);
				strAlls.append(",");
			}
		}
		if (strAlls.length() > 1) {
			return strAlls.substring(0, strAlls.length() - 1).split(",");
		} else {
			return null;
		}
	}
	
    /**
     * 得到首字母集合，简称
     * @param cnStr
     * @return
     */
	public static String getFirstSpellCollection(String cnStr) {
		return Cn2Spell.getFirstSpellCollection(cnStr);
	}
}