package org.quickbundle.mda.gc;

import java.io.IOException;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.Platform;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Text;
import org.quickbundle.mda.mvm.MvmActivator;
import org.quickbundle.tools.helper.io.RmFileHelper;
import org.quickbundle.tools.helper.xml.RmXmlHelper;

public class Config3MvmWizardPage extends WizardPage implements Listener {

    //Wizard对象
    private GenerateCodeRule gcRule = null;
    
	public Config3MvmWizardPage(GenerateCodeWizard currentWizard) {
        super("mvmWizardPage");
        setTitle("生成代码 3/3: 配置MVM参数");
        //setDescription("请填入所有参数，然后点完成！");
        this.gcRule = currentWizard.getGcRule();
    }

	public void createControl(Composite parent) {
        final int columns = 4; //定义列数
    	Composite container = null;
    	if(parent.getChildren() != null && parent.getChildren().length > 1 && parent.getChildren()[1] instanceof ScrolledComposite) {
    		ScrolledComposite scroll = (ScrolledComposite)parent.getChildren()[1];
    		container = new Composite(scroll, SWT.NULL);
    		scroll.setContent(container);
    	} else {
    		container = new Composite(parent, SWT.NULL);
    	}
        
    	container.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));
    	container.setLayout(new GridLayout(columns, false));
    	GridData gd = null;


    	Label labelTemplateSource = new Label(container, SWT.NULL);
    	labelTemplateSource.setText("请选择模板源:");
        gd = new GridData(GridData.CENTER);
        gd.horizontalSpan = columns;
        labelTemplateSource.setLayoutData(gd);
    	
        new Label(container, SWT.NULL).setText("模板URI");
        Combo serverTemplateSource = new Combo(container, SWT.BORDER | SWT.SINGLE);
        serverTemplateSource.setText(RmFileHelper.formatToFile(getMvmTemplateSource()));
        gd = new GridData(GridData.FILL_HORIZONTAL);
        gd.horizontalSpan = 3;
        gd.widthHint = 800;
        serverTemplateSource.setLayoutData(gd);
        
        createLine(container, columns);
        
    	Label labelFramework = new Label(container, SWT.NULL);
    	labelFramework.setText("请选择框架套餐:");
        gd = new GridData(GridData.CENTER);
        gd.horizontalSpan = columns;
        labelFramework.setLayoutData(gd);
    	
        new Label(container, SWT.NULL).setText("服务端");
        Combo serverFramework = new Combo(container, SWT.BORDER | SWT.SINGLE);
        serverFramework.setText("SpringMVC-3.2 + Spring-3.2 + MyBatis-3.2");
        gd = new GridData(GridData.FILL_HORIZONTAL);
        gd.horizontalSpan = 3;
        serverFramework.setLayoutData(gd);
        
        new Label(container, SWT.NULL).setText("PC UI端");
        Combo pcUiFramework = new Combo(container, SWT.BORDER | SWT.SINGLE);
        pcUiFramework.setText("jQuery-1.6 + Html");
        gd = new GridData(GridData.FILL_HORIZONTAL);
        gd.horizontalSpan = 3;
        pcUiFramework.setLayoutData(gd);

        createLine(container, columns);
        
    	Label labelProjectPropHead = new Label(container, SWT.NULL);
    	labelProjectPropHead.setText("请定义项目属性:");
        gd = new GridData(GridData.CENTER);
        gd.horizontalSpan = columns;
        labelProjectPropHead.setLayoutData(gd);
        //TODO 根据不同的框架套餐对应的mvm文件
        for(int i=0; i<1; i++) {
            new Label(container, SWT.NULL).setText("代码风格");
            Text projectProp1 = new Text(container, SWT.BORDER);
            projectProp1.setText("default");
            gd = new GridData(GridData.FILL_HORIZONTAL);
            gd.horizontalSpan = 3;
            projectProp1.setLayoutData(gd);
        }
        
        setControl(container);
	}
	
	String getMvmTemplateSource() {
		try {
			return RmXmlHelper.formatToUrl(FileLocator.getBundleFile(Platform.getBundle(MvmActivator.PLUGIN_ID)).getAbsolutePath() + "/target/classes/template");
		} catch (IOException e) {
			e.printStackTrace();
			return e.toString();
		}
	}
	
    //生成一行分隔线
    public static void createLine(Composite container, int ncol) {
        Label line = new Label(container, SWT.SEPARATOR | SWT.HORIZONTAL | SWT.BOLD);
        GridData gridData = new GridData(GridData.FILL_HORIZONTAL);
        gridData.horizontalSpan = ncol;
        line.setLayoutData(gridData);
    }

	public void handleEvent(Event event) {
		
	}

}
