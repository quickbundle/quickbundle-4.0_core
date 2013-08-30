package org.quickbundle.mda.template;

import java.sql.Timestamp;

import org.quickbundle.tools.helper.xml.RmXmlHelper;

public class JavaTemplateHelper {

    public static String getJavaFileDescComment(String outputFile) {
        StringBuilder result = new StringBuilder();
        result.append("//代码生成时,文件路径: ")
        	.append(RmXmlHelper.formatToUrlNoPrefix(outputFile))
        	.append("\n")
        	.append("//代码生成时,系统时间:")
        	.append(getSysDateTime())
        	.append(", 操作系统用户:")
        	.append(System.getProperty("user.name"))
        	.append("\n\n");
        return result.toString();
    }

    /**
     * 功能: 为xslt创建java文件注释
     * 
     * @param filePathName
     * @param projectName
     * @param authorName
     * @return
     */
    public static String getJavaFileComment(String authorName) {
    	StringBuilder result = new StringBuilder();
    	result.append("/*\n")
    		.append(" * 功能描述:\n")
    		.append(" * 版本历史: ")
    		.append(getSysDateTime())
    		.append(" 创建1.0.0版 (")
    		.append(authorName)
    		.append(")\n")
    		.append(" */");
        return result.toString();
    }
    
    private static String getSysDateTime() {
    	return new Timestamp(System.currentTimeMillis()).toString().substring(0,19);
    }

    /**
     * 功能: 为xslt创建class注释
     * 
     * @param authorName
     * @return
     */
    public static String getClassComment(String authorName) {
    	StringBuilder result = new StringBuilder();
    	result.append("/**\n")
    		.append(" * 功能、现存BUG:\n")
    		.append(" * \n")
    		.append(" * @author " + authorName + "\n")
    		.append(" */");
        return result.toString();
    }
}
