import {Button} from 'primereact/button';
import {Column} from 'primereact/column';
import {Dropdown} from 'primereact/dropdown';
import {TabView, TabPanel} from 'primereact/tabview';
import {DataTable} from 'primereact/datatable';
import {Dialog} from 'primereact/dialog';
import {InputNumber, InputNumberChangeEvent} from 'primereact/inputnumber';
import {InputText} from 'primereact/inputtext';
import {classNames} from 'primereact/utils';
import { InputTextarea } from 'primereact/inputtextarea';
import {AxiosResponse} from 'axios';
import React, {useEffect, useState} from 'react';
import {Calendar, CalendarChangeEvent} from 'primereact/calendar';
import { format } from 'date-fns';
import { InputSwitch } from "primereact/inputswitch";
import {MultiSelect} from "primereact/multiselect";
import  {${pojo.name?cap_first}Dto}  from '/pages/controller/model/${pojo.name?cap_first}.model';

const View = ({visible,onClose,selectedItem}) => {

    const emptyItem = new ${pojo.name}Dto();
    const [item, setItem] = useState<${pojo.name}Dto>(emptyItem);
    const [submitted, setSubmitted] = useState(false);
    const [activeIndex, setActiveIndex] = useState<number>(0);

    useEffect(() => {
        setItem(selectedItem ? { ...selectedItem } : { ...emptyItem });
    }, [selectedItem]);

    const onTabChange = (e: { index: number }) => {
        setActiveIndex(e.index);
    };

    const hideDialog = () => {
        setSubmitted(false);
        onClose();
    };

    const itemDialogFooter = ( <>
        <Button label="Cancel" icon="pi pi-times" text onClick={hideDialog} /> < />
    );

return(
<Dialog visible={visible} style={{width: '70vw'}} header="${pojo.name} Details" modal className="p-fluid" footer={itemDialogFooter} onHide={hideDialog} >
<TabView activeIndex={activeIndex} onTabChange={onTabChange}>
<TabPanel header="${pojo.name}">
    <div className="formgrid grid">
        <#list pojo.fields as field>
        <#if field.simple && !field.notVisibleInCreatePage>
        <#if  field.type.simpleName == "Date" || field.dateTime>
        <div className="field col-6">
            <label htmlFor="${field.name}">${field.name?cap_first}</label>
            <Calendar id="${field.name}" value={selectedItem?.${field.name}} disabled dateFormat="dd/mm/yy" showTime />
        </div>
        <#elseif  field.large>
            <div className="field col-6">
                <label htmlFor="${field.name}">${field.name?cap_first}</label>
                <span className="p-float-label">
                   <InputTextarea id="${field.name?uncap_first}" value={selectedItem?.${field.name}} disabled rows={5} cols={30} />
                </span>
            </div>
        <#elseif field.pureString>
            <div className="field col-6">
                <label htmlFor="${field.name?uncap_first}">${field.name?cap_first}</label>
                <InputText id="${field.name?uncap_first}" value={selectedItem?.${field.name?uncap_first}} disabled   />
            </div>
        <#elseif field.type.simpleName == "Boolean">
        <div className="field col-6">
            <div  class="label-inputswitch">
                <label htmlFor="${field.name?uncap_first}">${field.name?cap_first}</label>
                <span className="p-float-label">
            <InputSwitch  id="${field.name}" checked={selectedItem?.${field.name}} disabled />
             </span>
            </div>
            </div>
            <#elseif field.id == false>
                <div className="field col-6">
                    <label htmlFor="${field.name?uncap_first}">${field.name?cap_first}</label>
                    <InputNumber id="${field.name?uncap_first}" value={item.${field.name?uncap_first}} disabled/>
                </div>
            </#if>

            <#elseif field.generic && !field.notVisibleInCreatePage>
                <div className="field col-6">
                    <label htmlFor="${field.name?uncap_first}">${field.name?cap_first}</label>
                    <Dropdown  id="${field.name?uncap_first}Dropdown"  value={<#if field.typeAsPojo??>selectedItem?.${field.name?uncap_first}?.${field.typeAsPojo.labelOrReferenceOrId.name}<#else>${field..name}</#if>}  disabled  />
                </div>
            </#if>
            </#list>
        </div>
</TabPanel>
<#list pojo.fields as field>
    <#if field.list && (field.associationComplex || field.fakeAssociation)>
    <TabPanel header="${field.name}">
                <div className="card">
                    <DataTable value={selectedItem?.${field.name?uncap_first}} tableStyle={{minWidth: '50rem'}} dataKey="id">
                    <#list field.typeAsPojo.fields as myField>
                        <#if myField.simple && !myField.notVisibleInCreatePage>
                            <#if !myField.id>
                                <Column field="${myField.name}" header="${myField.formatedName}"></Column>
                            </#if>
                        <#elseif myField.generic && !myField.notVisibleInCreatePage>
                            <#if myField.typeAsPojo.name != pojo.name>
                                <Column field="${myField.name}.${myField.typeAsPojo.labelOrReferenceOrId.name!'walo'}" header="${myField.formatedName}"></Column>
                            </#if>
                        <#else>
                        </#if>
                    </#list>
                    </DataTable>
                </div>
        </TabPanel>
    </#if>
</#list>
</TabView>
</Dialog>
);
};
export default View;