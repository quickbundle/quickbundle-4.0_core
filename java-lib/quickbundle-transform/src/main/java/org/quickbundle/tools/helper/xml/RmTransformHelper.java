package org.quickbundle.tools.helper.xml;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.util.Map;

import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.Configuration;
import net.sf.saxon.value.Whitespace;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.DocumentSource;
import org.dom4j.io.SAXReader;
import org.quickbundle.project.init.RmConfig;

public class RmTransformHelper {
	/**
	 * 功能: 从转化中获取String
	 * 
	 * @param document
	 * @return
	 */
	public static String getStringFromTransform(String xsltPath, String myTableXml) {
		return getStringFromTransform(xsltPath, myTableXml, null);
	}
	/**
	 * 功能: 从转化中获取String
	 * 
	 * @param document
	 * @return
	 */
	public static String getStringFromTransform(String xsltPath, String myTableXml, Map<String, Object> mAttribute) {
		String returnStr = "";
		xsltPath = RmXmlHelper.formatToUrl(xsltPath);
		myTableXml = RmXmlHelper.formatToUrl(myTableXml);
		ByteArrayOutputStream bytesStream = new ByteArrayOutputStream();
		BufferedOutputStream outer = new BufferedOutputStream(bytesStream);
		Transformer transformer = null;
		try {
			Configuration config = new Configuration();
			config.setStripsAllWhiteSpace(true);
			config.setStripsWhiteSpace(Whitespace.ALL);
			TransformerFactory factory = new net.sf.saxon.TransformerFactoryImpl(config);
			Templates pss = factory.newTemplates(new StreamSource(xsltPath));
			transformer = pss.newTransformer();
			if(mAttribute != null) {
				for(String key : mAttribute.keySet()) {
					transformer.setParameter(key, mAttribute.get(key));
				}
			}
			transformer.transform(new StreamSource(myTableXml), new StreamResult(outer));
			returnStr = bytesStream.toString(RmConfig.defaultEncode());
		} catch (TransformerConfigurationException e) {
			throw new RuntimeException(e.toString(), e); 
		} catch (TransformerException e) {
			throw new RuntimeException(e.toString(), e); 
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e.toString(), e); 
		} finally {
			try {
				if (outer != null) {
					outer.close();
				}
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}

		return returnStr;
	}

	public static String getStringFromTransform(Document xsltDoc, Document xmlDoc) {
		String returnStr = "";
		ByteArrayOutputStream bytesStream = new ByteArrayOutputStream();
		BufferedOutputStream outer = new BufferedOutputStream(bytesStream);
		Transformer transformer = null;
		try {
			Configuration config = new Configuration();
			config.setStripsAllWhiteSpace(true);
			config.setStripsWhiteSpace(Whitespace.ALL);
			TransformerFactory factory = new net.sf.saxon.TransformerFactoryImpl(config);
			Templates pss = factory.newTemplates(new DocumentSource(xsltDoc));
			transformer = pss.newTransformer();
			transformer.transform(new DocumentSource(xmlDoc), new StreamResult(outer));
			returnStr = bytesStream.toString(RmConfig.defaultEncode());
		} catch (TransformerConfigurationException e) {
			throw new RuntimeException("", e); 
		} catch (TransformerException e) {
			throw new RuntimeException("", e); 
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException("", e); 
		} finally {
			try {
				if (outer != null) {
					outer.close();
				}
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}

		return returnStr;
	}
	
	public static String getStringFromTransform4Str(String xsltStr, String xmlStr) {
		Document xsltDoc = RmXmlHelper.getDocumentFromString(xsltStr);
		Document xmlDoc = RmXmlHelper.getDocumentFromString(xmlStr);
		return getStringFromTransform(xsltDoc, xmlDoc);
	}

	/**
	 * 功能: 从转化中获取document
	 * 
	 * @param xsltPath
	 * @param myTableXml
	 * @return
	 * @throws DocumentException
	 */
	public static Document getDocumentFromTransform(String xsltPath, String myTableXml) throws DocumentException {
		return new SAXReader().read(new StringReader(getStringFromTransform(xsltPath, myTableXml)));
	}
}
