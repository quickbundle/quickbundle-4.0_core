package org.quickbundle.mda.template;

import org.quickbundle.tools.helper.xml.RmXmlHelper;

public class JavaTemplateHelper {

    public static String getJavaFileDescComment(String outputFile) {
        String returnStr = "";
        returnStr += "//代码生成时,文件路径: " + RmXmlHelper.formatToUrlNoPrefix(outputFile) + "\n";
        returnStr += "//代码生成时,系统时间: " + RmXmlHelper.getSysDateTime() + "\n";
        returnStr += "//代码生成时,操作系统用户: " + System.getProperty("user.name") + "\n\n";
        return returnStr;
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
        String returnStr = "";
        returnStr += "/*\n";
        returnStr += " * 系统名称:单表模板 --> " + projectName + "\n";
        returnStr += " * \n";
        returnStr += " * 文件名称: " + filePathName + "\n";
        returnStr += " * \n";
        returnStr += " * 功能描述:\n";
        returnStr += " * \n";
        returnStr += " * 版本历史: " + RmXmlHelper.getSysDateTime() + " 创建1.0.0版 (" + authorName + ")\n";
        returnStr += " *  \n";
        returnStr += " */\n";
        return returnStr;
    }

    /**
     * 功能: 为xslt创建class注释
     * 
     * @param authorName
     * @return
     */
    public static String getClassComment(String authorName) {
        String returnStr = "";
        returnStr += "/**\n";
        returnStr += " * 功能、用途、现存BUG:\n";
        returnStr += " * \n";
        returnStr += " * @author " + authorName + "\n";
        returnStr += " * @version 1.0.0\n";
        returnStr += " * @see 需要参见的其它类\n";
        returnStr += " * @since 1.0.0\n";
        returnStr += " */\n";

        return returnStr;
    }
    
    /**
     * 功能: 为xslt创建引用子表的html代码
     * 
     * @param authorName
     * @return
     */
    public static String getParentChildHtmlCode(String parentChildTable, String upperFirstTablePk) {
    	StringBuilder sb = new StringBuilder();
    	parentChildTable = parentChildTable.trim();
    	parentChildTable = parentChildTable.replaceAll("[\\s,]+$", "");
    	String[] aStr = parentChildTable.split(",");
    	for (int i = 0; i < aStr.length; i++) {
    		if(aStr[i].trim().length() > 0 && aStr[i].indexOf("=") > -1 && aStr[i].indexOf(".") > -1) {
				String pcr = aStr[i].substring(aStr[i].indexOf("=") + 1).trim();
				String childTableFormatName = pcr.substring(0, pcr.indexOf("."));
				String childFkField = pcr.substring(pcr.indexOf(".")+1, pcr.indexOf("|") > -1 ? pcr.indexOf("|") : pcr.length()).toLowerCase();
				sb.append("new Array ('子表" + childTableFormatName + "','<%=request.getContextPath()%>/" + childTableFormatName + "ConditionAction.do?cmd=queryAll&" + childFkField + "=<%=resultVo.get" + upperFirstTablePk + "()%><%=isReadOnly ? \"&\" + org.quickbundle.project.IGlobalConstants.REQUEST_IS_READ_ONLY + \"=1\" : \"\"%>')");
				if(i < aStr.length-1) {
					sb.append(",\n");
				}
    		}
		}
        return sb.toString();
    }
}
