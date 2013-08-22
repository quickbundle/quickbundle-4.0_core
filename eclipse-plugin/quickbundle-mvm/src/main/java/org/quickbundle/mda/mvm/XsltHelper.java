package org.quickbundle.mda.mvm;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.RandomAccessFile;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.xml.transform.TransformerException;

import org.quickbundle.tools.helper.io.RmFileHelper;
import org.quickbundle.tools.helper.xml.RmTransformHelper;
import org.quickbundle.tools.helper.xml.RmXmlHelper;

public class XsltHelper {

    public static String getJavaFileDescComment(String targetPath) {
        String returnStr = "";
        returnStr += "//代码生成时,文件路径: " + RmXmlHelper.formatToUrlNoPrefix(targetPath) + "\n";
        returnStr += "//代码生成时,系统时间: " + RmXmlHelper.getSysDateTime() + "\n";
        returnStr += "//代码生成时,操作系统用户: " + System.getProperty("user.name") + "\n\n";
        return returnStr;
    }

    /**
     * 功能:输出转化文件
     * 
     * @param xsltPath
     * @param myTableDoc
     * @param targetPath
     * @throws TransformerException
     */
    public static void outPutFile(String xsltPath, String myTableXml, String targetPath) {
        targetPath = RmXmlHelper.formatToFile(targetPath);
        RmFileHelper.initParentDir(targetPath); //创建父目录
        try {
            String context = RmTransformHelper.getStringFromTransform(xsltPath, myTableXml);
            if (targetPath.endsWith(".java")) {
                context = getJavaFileDescComment(targetPath) + context;
            }
            RmFileHelper.saveFile(context, targetPath);
        } catch (Exception e) {
        	EclipseLog.logError("xsltPath=" + xsltPath + ", myTableXml=" + myTableXml + "," + e.toString(), e);
            e.printStackTrace();
        }
    }
    
    /**
     * 功能:转化文件，模板有初始化参数
     * 
     * @param xsltPath
     * @param myTableXml
     * @param targetPath
     * @param mAttribute
     */
    public static void outPutFile4ResultDocument(String xsltPath, String myTableXml, String targetPath) {
    	RmFileHelper.initSelfDir(RmXmlHelper.formatToFile(targetPath)); //创建目录
    	Map<String, Object> mAttribute = new HashMap();
    	mAttribute.put("targetFullPath", RmXmlHelper.formatToUrl(targetPath));
        try {
            RmTransformHelper.getStringFromTransform(xsltPath, myTableXml, mAttribute);
        } catch (Exception e) {
        	EclipseLog.logError("xsltPath=" + xsltPath + ", myTableXml=" + myTableXml + "," + e.toString(), e);
            e.printStackTrace();
        }
        {//如果目录为空则删除
        	File fTargetFolder = new File(RmXmlHelper.formatToFile(targetPath));
        	if(fTargetFolder.isDirectory() && fTargetFolder.list().length == 0) {
        		fTargetFolder.delete();
        	}
        }
    }

    /**
     * 功能:输出转化后的字符到指定文件
     * 
     * @param xsltPath
     * @param myTableDoc
     * @param targetPath
     * @param afterKeyWord
     */
    public static void outPutFile(String xsltPath, String myTableXml, String targetPath, String afterKeyWord, boolean rowIsUnique) {
        targetPath = RmXmlHelper.formatToUrl(targetPath);
        RmFileHelper.initParentDir(targetPath); //创建父目录
        String context = "";
        try {
        	context = RmTransformHelper.getStringFromTransform(xsltPath, myTableXml);
		} catch (Exception e) {
			EclipseLog.logError("xsltPath=" + xsltPath + ", myTableXml=" + myTableXml + "," + e.toString(), e);
			e.printStackTrace();
		}
        
        writeToRandomFile(targetPath, context, afterKeyWord, rowIsUnique);
    }

    /**
     * 功能: 随机访问文件tartetPath,把context插到afterKeyWord后边
     * 
     * @param targetPath
     * @param context
     * @param afterKeyWord
     */
    public static void writeToRandomFile(String targetPath, String content, String afterKeyWord, boolean rowIsUnique) {
        BufferedReader in = null;
        RandomAccessFile rf = null;
        targetPath = RmXmlHelper.formatToFile(targetPath);
        StringBuffer targetPathStr = new StringBuffer();
        try {
            if (new File(targetPath).exists()) { //检查是否已经存在相同代码
            	in = new BufferedReader(new InputStreamReader(new FileInputStream(targetPath), "UTF-8"));
                String s1 = null;
                while ((s1 = in.readLine()) != null) {
                    targetPathStr.append(s1 + "\n");
                }
                if (targetPathStr.toString().indexOf(content.trim()) >= 0) { //已经存在 （截掉制表符，减少重复写入文件的可能）
                    return;
                }
            }
            if(rowIsUnique) { //如果每一行数据不能重复
                Set sTargetPathRow = new HashSet();
                String[] aTargetPathRow = targetPathStr.toString().split("\n");
                for (int i = 0; i < aTargetPathRow.length; i++) {
                    if(aTargetPathRow[i].trim().length() > 0) {
                        sTargetPathRow.add(aTargetPathRow[i].trim());
                    }
                }
                targetPathStr = null;
                //开始找位置
                String line = null;
                long position = 0;
                rf = new RandomAccessFile(targetPath, "rw");
                while (true) {
                    line = rf.readLine();
                    if (line != null) {
                        if (line.trim().equals(afterKeyWord)) {
                            position = rf.getFilePointer();
                            break;
                        }
                    } else {
                        position = rf.getFilePointer();
                        break;
                    }
                }
                StringBuffer originRemain = new StringBuffer();
                while ((line = rf.readLine()) != null) {
                    originRemain.append(line + "\n");
                }
                rf.seek(position);
                //开始写文件
                String[] aContentRow = content.split("\n");
                for (int i = 0; i < aContentRow.length; i++) {
                    String tempContentRow = null;
                    if(sTargetPathRow.contains(aContentRow[i].trim())) { //如果出现重复行
                        if(targetPath.endsWith("xml")) {
                            tempContentRow = "<!--" + aContentRow[i] + "-->";
                        } else if(targetPath.endsWith("java")) {
                            tempContentRow = "//" + aContentRow[i];
                        } else if(targetPath.endsWith("properties")) {
                            tempContentRow = "#" + aContentRow[i];
                        }
                    } else {
                        tempContentRow = aContentRow[i];
                    }
                    tempContentRow += "\n";
                    rf.write(tempContentRow.getBytes("UTF-8"));
                }
                rf.writeBytes(originRemain.toString());
            } else { //每一行数据可以重复
                //开始找位置
                String line = null;
                long position = 0;
                rf = new RandomAccessFile(targetPath, "rw");
                while (true) {
                    line = rf.readLine();
                    if (line != null) {
                        if (line.trim().equals(afterKeyWord)) {
                            position = rf.getFilePointer();
                            break;
                        }
                    } else {
                        position = rf.getFilePointer();
                        break;
                    }
                }
                StringBuffer originRemain = new StringBuffer();
                while ((line = rf.readLine()) != null) {
                    originRemain.append(line + "\n");
                }
                rf.seek(position);
                //开始写文件
                rf.write(content.getBytes("UTF-8"));
                //rf.write(new String(originRemain.getBytes("iso8859-1"),"UTF-8").getBytes("UTF-8"));
                rf.writeBytes(originRemain.toString());
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(in != null) {
                    in.close();
                }
                if (rf != null) {
                    rf.close();
                }
            } catch (IOException e2) {
                e2.printStackTrace();
            }
        }
    }
    
}
