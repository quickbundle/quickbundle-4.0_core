package org.quickbundle.tools.helper.xml;
/*
 * 系统名称:Quickbundle.org --> ranminXmlGenerateCode
 * 
 * 文件名称: ranminXmlGenerateCode.test --> TestScroll.java
 * 
 * 功能描述:
 * 
 * 版本历史: 2005-12-4 2:46:28 创建1.0.0版 (baixiaoyong)
 *  
 */

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.DocumentSource;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
import org.quickbundle.project.init.RmConfig;
import org.quickbundle.tools.helper.io.RmFileHelper;

/**
 * 功能、用途、现存BUG:
 * 
 * @author 白小勇
 * @version 1.0.0
 * @see 需要参见的其它类
 * @since 1.0.0
 */
public class RmXmlHelper {

    /**
     * 功能: 从Document对象中获取String
     * 
     * @param document
     * @return
     */
    public static String getStringFromDocument(Document document) {
        String returnStr = "";
        ByteArrayOutputStream bytesStream = new ByteArrayOutputStream();
        BufferedOutputStream outer = new BufferedOutputStream(bytesStream);

        TransformerFactory tFactory = TransformerFactory.newInstance();
        Transformer transformer = null;
        try {
            transformer = tFactory.newTransformer();
            transformer.setOutputProperty("encoding", RmConfig.defaultEncode());
            transformer.setOutputProperty("indent", "yes");
            transformer.transform(new DocumentSource(document), new StreamResult(outer));
            returnStr = bytesStream.toString(RmConfig.defaultEncode());
        } catch (TransformerConfigurationException e) {
            e.printStackTrace();
        } catch (TransformerException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return returnStr;
    }

    /**
     * 转化xml字符串为Document对象
     * 
     * @param xmlStr
     * @return
     */
    public static Document getDocumentFromString(String xmlStr) {
        try {
			return new SAXReader().read(new StringReader(xmlStr));
		} catch (DocumentException e) {
			throw new RuntimeException("", e);
		}
    }
    
    /**
     * 获得一个Rss2.0格式的Document对象 --rss
     * @param channelTitle
     * @param channelLink
     * @param channelDescription
     * @return
     */
    public static Document getRss20Document(String channelTitle, String channelLink, String channelDescription) {
    	Document doc = DocumentHelper.createDocument();
    	Element rootEle = doc.addElement("rss").addAttribute("version", "2.0");
    	Element channelEle = rootEle.addElement("channel");
    	channelEle.addElement("title").setText(channelTitle);
    	channelEle.addElement("link").setText(channelLink);
    	channelEle.addElement("description").setText(channelDescription);
    	return doc;
    }
    
    /**
     * 获得一个Rss2.0格式的Document对象--item
     * @param itemTitle
     * @param itemLink
     * @param itemDescription
     * @param pubDate
     * @return
     */
    public static Document getRss20Item(String itemTitle, String itemLink, String itemDescription, String pubDate) {
    	Document doc = DocumentHelper.createDocument();
    	Element itemEle = doc.addElement("item");
    	itemEle.addElement("title").setText(itemTitle);
    	itemEle.addElement("link").setText(itemLink);
    	itemEle.addElement("description").setText(itemDescription);
    	itemEle.addElement("pubDate").setText(pubDate);
    	return doc;
    }

    /**
     * 功能: 从xmlPath的资源转化成Document对象
     * 
     * @param ruleXml
     * @return
     * @throws MalformedURLException
     * @throws DocumentException
     */
    public static Document parse(String xmlPath) throws MalformedURLException, DocumentException {
        if (xmlPath == null || xmlPath.length() == 0) {
            throw new NullPointerException("xml路径是空!");
        }
        SAXReader reader = new SAXReader();
        Document document = reader.read(new URL(formatToUrl(xmlPath)));
        return document;
    }
    
    /**
     * 功能: 从xmlPath的资源转化成Document对象，带命名空间
     * @param ruleXml
     * @param mNamespaceURIs
     * @return
     * @throws MalformedURLException
     * @throws DocumentException
     */
    public static Document parse(String ruleXml, Map mNamespaceURIs) throws MalformedURLException, DocumentException {
        if (ruleXml == null || ruleXml.length() == 0) {
            throw new NullPointerException("xml路径是空!");
        }
        SAXReader reader = new SAXReader();
        reader.getDocumentFactory().setXPathNamespaceURIs(mNamespaceURIs);
        Document document = null;
        if (ruleXml.startsWith("file:")) {
            document = reader.read(new URL(ruleXml));
        } else {
            document = reader.read(new File(ruleXml));
        }

        return document;
    }

    /**
     * 功能: 把xml保存到指定的路径文件名
     * 
     * @param document
     * @param targetFile
     * @throws IOException
     */
    public static boolean saveXmlToPath(Document document, String targetFile) {
        try {
            targetFile = formatToFile(targetFile);
            initParentDir(targetFile);
            OutputFormat format = OutputFormat.createPrettyPrint();
            format.setEncoding(RmConfig.defaultEncode());
            XMLWriter writer = new XMLWriter(new FileOutputStream(targetFile), format);
            writer.write(document);
            writer.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 功能: 将路径格式化为url --> file:///c:/rmdemo.log
     * 
     * @param filePath
     * @return
     */
    public static String formatToUrl(String filePath) {
    	if(filePath == null) {
    		return null;
    	}
        filePath = filePath.replaceFirst("file:[/\\\\]*", "");
        filePath = filePath.replaceAll("[/\\\\]+", "/");
        if (filePath.startsWith("/")) {
            filePath = "file://" + filePath;        	
        } else {
        	filePath = "file:///" + filePath;        	
        }
        return filePath;
    }
    
    /**
     * 功能: 将路径格式化为url --> c:/rmdemo.log
     * 
     * @param filePath
     * @return
     */
    public static String formatToUrlNoPrefix(String filePath) {
    	if(filePath == null) {
    		return null;
    	}
    	filePath = formatToUrl(filePath);
    	if(File.separator.endsWith("/")) {
    		filePath = filePath.substring("file://".length());
    	} else {
    		filePath = filePath.substring("file:///".length());
    	}
    	return filePath;
    }
    
    /**
     * 功能: 将路径格式化为File形式 --> c:\rmdemo.log
     * 
     * @param filePath
     * @param osSeparatorStr 指定当前操作系统分隔符
     * @return
     */
    public static String formatToFile(String filePath, String osSeparatorStr) {
    	if(filePath == null) {
    		return null;
    	}
        String osSeparatorRegex = ("\\".equals(osSeparatorStr)) ? "\\\\" : osSeparatorStr;
        filePath = filePath.replaceFirst("file:[/\\\\]*", "");
        filePath = filePath.replaceAll("[/\\\\]+", osSeparatorRegex);
        //自动补齐Linux下的/
        if("/".equals(osSeparatorStr) && !filePath.startsWith("/")) {
            filePath = "/" + filePath;
        }
        return filePath;
    }
    
    /**
     * 功能: 将路径格式化为File形式 --> c:\rmdemo.log
     *
     * @param filePString
     * @return
     */
    public static String formatToFile(String filePString) {
        return formatToFile(filePString, File.separator);
    }

    /**
     * 显示数据前过滤掉null
     * 
     * @param myString
     * @return
     */
    public static String prt(String myString) {
        if (myString != null)
            return myString;
        else
            return "";
    }
    

    /**
     * @deprecated
     * 功能: 随机访问文件tartetPath,把context插到afterKeyWord后边
     * 
     * @param targetPath
     * @param context
     * @param afterKeyWord
     */
    public static void writeToRandomFile(String targetPath, String context, String afterKeyWord) {
    	RmFileHelper.writeToRandomFile(targetPath, context, afterKeyWord);
    }

    /**
     * @deprecated
     * 功能: 拷贝文件
     * 
     * @param sourceFile
     * @param targetFile
     * @return
     * @throws Exception
     */
    public static boolean copyFile_reader(File sourceFile, File targetFile) throws Exception {
    	return RmFileHelper.copyFile_reader(sourceFile, targetFile);
    }
    
    /**
     * @deprecated
     * 功能: 拷贝文件
     * 
     * @param sourceFile
     * @param targetFile
     * @return
     * @throws Exception
     */
    public static boolean copyFile(File sourceFile, File targetFile) throws Exception {
    	RmFileHelper.copyFile(sourceFile, targetFile);
    	return true;
    }

    /**
     * @deprecated
     * 功能: 保存String到targetFile中
     * 
     * @param context
     * @param targetFile
     * @return
     * @throws Exception
     */
    public static boolean saveFile(String context, String targetFile) throws Exception {
    	return RmFileHelper.saveFile(context, targetFile);
    }

    /**
     * @deprecated
     * 功能: 为目标创建父目录
     * 
     * @param targetPath
     */
    public static String initParentDir(String targetPath) {
    	return RmFileHelper.initParentDir(targetPath);
    }

    /**
     * @deprecated
     * 功能: 为目标创建目录并返回
     * 
     * @param targetPath
     */
    public static String initSelfDir(String targetPath) {
    	return RmFileHelper.initSelfDir(targetPath);
    }

    /**
     * @deprecated
     * 复制整个文件夹内容
     * 
     * @param oldPath String 原文件路径
     * @param newPath String 复制后路径
     * @return boolean
     */
    public static void copyFolder(String oldPath, String newPath) {
    	RmFileHelper.copyFolder(oldPath, newPath);
    }
    
	/**
	 * @deprecated
	 * 递归删除目录
	 * 
	 * @param filepath
	 * @throws IOException
	 */
	public static void delDir(String filepath) throws IOException {
		RmFileHelper.delDir(filepath);
	}

    /**
     * 功能: 为xslt创建java文件注释
     * 
     * @param filePathName
     * @param projectName
     * @param authorName
     * @return
     */
    public static String getJavaFileComment(String filePathName, String projectName, String authorName) {
        StringBuilder returnStr = new StringBuilder();
        returnStr.append("/*\n");
        returnStr.append(" * 系统名称:单表模板 --> " + projectName + "\n");
        returnStr.append(" * \n");
        returnStr.append(" * 文件名称: " + filePathName + "\n");
        returnStr.append(" * \n");
        returnStr.append(" * 功能描述:\n");
        returnStr.append(" * \n");
        returnStr.append(" * 版本历史: " + getSysDateTime() + " 创建1.0.0版 (" + authorName + ")\n");
        returnStr.append(" *  \n");
        returnStr.append(" */\n");
        return returnStr.toString();
    }

    /**
     * 功能: 为xslt创建class注释
     * 
     * @param authorName
     * @return
     */
    public static String getClassComment(String authorName) {
    	StringBuilder returnStr = new StringBuilder();
        returnStr.append("/**\n");
        returnStr.append(" * 功能、用途、现存BUG:\n");
        returnStr.append(" * \n");
        returnStr.append(" * @author " + authorName + "\n");
        returnStr.append(" * @version 1.0.0\n");
        returnStr.append(" * @see 需要参见的其它类\n");
        returnStr.append(" * @since 1.0.0\n");
        returnStr.append(" */\n");

        return returnStr.toString();
    }
    
	/**
	 * 取Java虚拟机系统时间, 返回当前日期和时间
	 * 
	 * @return 返回String格式的日期和时间, YYYY-MM-DD HH24:MI:SS， 长19位
	 */
	public static String getSysDateTime() {
		return new Timestamp(System.currentTimeMillis()).toString().substring(0,19);
	}
	
//    /**
//     * 用于数据交换的doc压缩
//     * @param doc
//     * @param files
//     * @return
//     */
//    public static File createZipFile(Document doc, File[] files) {
//        File tmpXml = new File(new File(System.getProperty("java.io.tmpdir")) + File.separator + "dec" + File.separator + "main.xml");
//        RmXmlHelper.saveXmlToPath(doc, tmpXml.getAbsolutePath());
//        File[] files2 = null;
//        if (files != null && files.length > 0) {
//            files2 = new File[files.length + 1];
//            files2[0] = tmpXml;
//            for (int i = 0; i < files.length; i++) {
//                files2[i + 1] = files[i];
//            }
//        } else {
//            files2 = new File[1];
//            files2[0] = tmpXml;
//        }
//        return RmZipHelper.createZipFile(files2);
//    }

    public static void main(String[] args) {
        try {
            String ruleXml = "/home/qb/dev/eclipse_home/workspace_eclipse-reporting-galileo-SR2-linux-gtk/projectName/webAppName/WEB-INF/config/jdbc/id.xml";
            ruleXml = formatToUrl(ruleXml);
            SAXReader reader = new SAXReader();
            Map<String, String> defaultNameSpaceMap = new HashMap<String, String>();  
            defaultNameSpaceMap.put("q", "http://www.quickbundle.org/schema");
            reader.getDocumentFactory().setXPathNamespaceURIs(defaultNameSpaceMap);
            Document doc = null;
            if (ruleXml.startsWith("file:")) {
                doc = reader.read(new URL(ruleXml));
            } else {
                doc = reader.read(new File(ruleXml));
            }
            System.out.println(getStringFromDocument(doc));
            System.out.println(doc.selectNodes("//q:table").size());
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            String ruleXml = "E:/platform/myProject/navinfo/code/nifl/nifl/WEB-INF/config/rm/initCodeTypeData.xml";
            ruleXml = formatToUrl(ruleXml);
            SAXReader reader = new SAXReader();
            Document doc = null;
            if (ruleXml.startsWith("file:")) {
                doc = reader.read(new URL(ruleXml));
            } else {
                doc = reader.read(new File(ruleXml));
            }
            Set<String> s = new HashSet<String>();
            for(Object o : doc.selectNodes("//@code_type")) {
            	Node node = (Node)o;
            	if(s.contains(node.getText())) {
            		System.out.println(node.getText());
            	}
            	s.add(node.getText());
            }
//            System.out.println(s);
            System.out.println(getRss20Item("a", "b", "c", "d"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        
  }
    
}