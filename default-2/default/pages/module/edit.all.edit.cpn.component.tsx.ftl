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
import {InputNumberChangeEvent} from 'primereact/inputnumber';
import { InputSwitch } from "primereact/inputswitch";
import {MultiSelect} from "primereact/multiselect";import {MessageService} from "/pages/controller/service/MessageService";

import {${pojo.name}Service} from '/pages/controller/service/${pojo.name}.service';
import  {${pojo.name?cap_first}Dto}  from '/pages/controller/model/${pojo.name?cap_first}.model';

<#if pojo.dependencies??>
    <#list pojo.dependencies as dependency>
        <#if dependency?? && dependency.name??>
import {${dependency.name?cap_first}Dto} from '/pages/controller/model/${dependency.name?cap_first}.model';
import {${dependency.name?cap_first}Service} from '/pages/controller/service/${dependency.name?cap_first}.service';
        </#if>
    </#list>
</#if>
const Edit = ({visible, onClose, showToast, selectedItem, update}) => {

    const emptyItem = new ${pojo.name}Dto();
    const [submitted, setSubmitted] = useState(false);
    const [activeIndex, setActiveIndex] = useState<number>(0);
    const [activeTab, setActiveTab] = useState(0);
    const [item, setItem] = useState<${pojo.name?cap_first}Dto>( emptyItem);
<#if pojo.dependencies??>
    <#list pojo.dependencies as dependency>
        <#if dependency?? && dependency.name??>
    const [${dependency.name?uncap_first}s, set${dependency.name?cap_first}s] = useState<${dependency.name?cap_first}Dto[]>([]);
    type ${dependency.name?cap_first}Response = AxiosResponse<${dependency.name?cap_first}Dto[]>;
        </#if>
    </#list>
</#if>
<#list pojo.fields as field>
    <#if field.list>
    const [${field.typeAsPojo.name?uncap_first}, set${field.typeAsPojo.name?cap_first}] = useState<${field.typeAsPojo.name}Dto>(new ${field.typeAsPojo.name}Dto());
    </#if>
</#list>

    useEffect(() => {
        const fetchData = async () => {
            try {
                // if pojo = Commande this line must dispolay client (in command), product(in commanandItem)
            <#assign i=0>
                const [<#list pojo.fieldsGenericIncludingInnerTypeInListField as fieldGeneric>${fieldGeneric.name?uncap_first}sResponse <#if fieldGeneric?index != pojo.fieldsGenericIncludingInnerTypeInListField?size -1>,</#if></#list>] = await Promise.all<<#list pojo.fieldsGenericIncludingInnerTypeInListField as fieldGeneric>${fieldGeneric.name?cap_first}Response<#if fieldGeneric?index != pojo.fieldsGenericIncludingInnerTypeInListField?size -1>,</#if></#list>>([
            <#list pojo.fieldsGenericIncludingInnerTypeInListField as fieldGeneric>
                    ${fieldGeneric.name?cap_first}Service.getList(),
            </#list>
                ]);
            <#list pojo.fieldsGenericIncludingInnerTypeInListField as fieldGeneric>
                set${fieldGeneric.name?cap_first}s(${fieldGeneric.name?uncap_first}sResponse.data);
            </#list>
            } catch (error) {
                console.error(error);
            }
        };
    fetchData();
    setItem(selectedItem ? { ...selectedItem } : { ...emptyItem });
    }, [selectedItem]);



    const onDropdownChange = (e, field) => {
        setItem((prevState) => ({ ...prevState, [field]: e.value, }));
    };

<#list pojo.fields as field>
    <#if field.list && !field.association>
    const add${field.name?cap_first} = () => {
        setSubmitted(true);
        if( item.${field.name?uncap_first} == null )
        item.${field.name?uncap_first} = new Array<${field.typeAsPojo.name?cap_first}Dto>();
        let _item = ${field.typeAsPojo.name?uncap_first};
        if (!_item.id) {
            item.${field.name?uncap_first}.push(_item);
            MessageService.showToast(showToast, { severity: 'success', summary: 'Successful', detail: '${field.typeAsPojo.name?cap_first} Created', life: 3000 });
            setItem((prevState :any) => ({...prevState, ${field.name?uncap_first}: item.${field.name?uncap_first} }));
        } else {
            const updatedItems = item.${field.name?uncap_first}.map((item) => item.id === ${field.typeAsPojo.name?uncap_first}.id ? {...${field.typeAsPojo.name?uncap_first}} : item);
            MessageService.showToast(showToast, { severity: 'success', summary: 'Successful', detail: '${field.typeAsPojo.name?cap_first} Updated', life: 3000 });
            setItem((prevState :any) => ({ ...prevState, ${field.name?uncap_first}: updatedItems}));
        }
        set${field.typeAsPojo.name?cap_first}(new ${field.typeAsPojo.name}Dto());
    };

    const delete${field.typeAsPojo.name} = (rowData) => {
        const updatedItems = item.${field.name}.filter((val) => val !== rowData);
        setItem((prevState ) => ({...prevState, ${field.name}: updatedItems }));
        set${field.typeAsPojo.name}(new ${field.typeAsPojo.name}Dto());
        MessageService.showToast(showToast, {severity: 'success', summary: 'Successful', detail: '${pojo.name?cap_first}Item Deleted', life: 3000});
    };

    const edit${field.typeAsPojo.name} = (rowData) => {
        setActiveTab(0);
        set${field.typeAsPojo.name}(rowData);
    };

    const onInputNumerChange${field.name?cap_first} = (e, name) => {
        const val = e.value || 0;
        set${field.typeAsPojo.name}((prev${field.name?cap_first}) => ({ ...prev${field.name?cap_first}, [name]: val, }));
    };

    const onDropdownChange${field.name?cap_first} = (e, field) => {
        set${field.typeAsPojo.name}((prevState) => ({ ...prevState, [field]: e.value}));
    };


    const onMultiSelectChange${field.name?cap_first} = (e, field) => {
        if (e && e.value && Array.isArray(e.value)) {
            const selectedValues = e.value.map(option => option && option.value);
            set${field.typeAsPojo.name}(prevState => ({ ...prevState, [field]: selectedValues, }));
        }
    };

    const onBooleanInputChange${field.name?cap_first} = (e: any, name: string) => {
        const val = e.value;
        set${field.typeAsPojo.name}((prevItem) => ({ ...prevItem, [name]: val, }));
    };

    const onInputDateChange${field.name?cap_first} = (e: CalendarChangeEvent, name: string) => {
        const val = e.value || ''; // Utilisez e.value au lieu de e.target.value
        let _item = { ...${field.typeAsPojo.name?uncap_first}};
        _item[`<#noparse>${name}</#noparse>`] = val;
        set${field.typeAsPojo.name}(_item);
    };


    const onInputTextChange${field.name?cap_first} = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>, name: string) => {
        const val = (e.target && e.target.value) || '';
        let _item = {...${field.typeAsPojo.name?uncap_first}};
        _item[`<#noparse>${name}</#noparse>`] = val;
        set${field.typeAsPojo.name}(_item);
    };
    </#if>
</#list>

    const onTabChange = (e: { index: number }) => {
        setActiveIndex(e.index);
    };

    const hideDialog = () => {
        setSubmitted(false);
        onClose();
    };

    const saveItem = async () => {
        setSubmitted(true);
        let _item = {...item};
        try {
            if (_item.id) {
                await ${pojo.name?cap_first}Service.update(_item).then((response) => {
                    console.log(response.data);
                    update(response.data);
                    onClose();
                });
                MessageService.showToast(showToast, { severity: 'success', summary: 'Successful', detail: '${pojo.name?cap_first} Updated', life: 3000 });
            }
        } catch (error) {
            console.log(error);
            MessageService.showToast(showToast, { severity: 'Error', summary: 'Error', detail: 'Failed to save ${pojo.name?uncap_first}', life: 3000 });
        }
    };

    const onInputTextChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>, name: string) => {
        const val = (e.target && e.target.value) || '';
        let _item = {...item};
        _item[`<#noparse>${name}`</#noparse>] = val;
        setItem(_item);
    };

    const onInputDateChange = (e: CalendarChangeEvent, name: string) => {
        const val = e.value || ''; // Utilisez e.value au lieu de e.target.value
        let _item = { ...item};
        _item[`<#noparse>${name}</#noparse>`] = val;
        setItem(_item);
    };

    const onInputNumerChange = (e: InputNumberChangeEvent, name: string) => {
        const val = e.value === null ? null : +e.value;
        setItem((prevItem) => ({ ...prevItem, [name]: val, }));
    };

    const onMultiSelectChange = (e, field) => {
        if (e && e.value && Array.isArray(e.value)) {
            const selectedValues = e.value.map(option => option && option.value);
            setItem(prevState => ({ ...prevState, [field]: selectedValues, }));
        }
    };

    const onBooleanInputChange = (e: any, name: string) => {
        const val = e.value;
        setItem((prevItem) => ({ ...prevItem, [name]: val, }));
    };

    const itemDialogFooter = ( <>
        <Button label="Cancel" icon="pi pi-times" text onClick={hideDialog} />
        <Button label="Save" icon="pi pi-check" text onClick={saveItem} /> < />
    );

return(
    <#if pojo.createUpdateConfounded>
    <p-toast></p-toast>
    <div class="card">
    <message severity="{{info}}" text="{{msgsContents}}"></message>
    </div>
    <div class="p-fluid">
    <#else>
    <Dialog visible={visible} style={{width: '70vw'}} header="${pojo.name}" modal className="p-fluid" footer={itemDialogFooter} onHide={hideDialog}>
    </#if>
    <#if pojo.steps>
    <div class="card">
        <p-toast></p-toast>
        <p-steps [model]="steps" [(activeIndex)]="next" [readonly]="true">
        </p-steps>
    </div>
    </#if>
    <#if pojo.steps>
    <#list pojo.steper.steps as myStep>
        <div *ngIf="next == ${myStep?index}">
            <div class="grid">
                <#list myStep.fields as field>
                    <#if field.list && field.association>
                        <div class="field col-12  md:col-${pojo.columnStyle}">
                            <label>${field.fieldOfAssociation.formatedName}</label>
                            <p-multiSelect [options]="${field.name}" [(ngModel)]="item.${field.name}" itemSize="30" [virtualScroll]="true"
                                           defaultLabel="Select un ${field.fieldOfAssociation.name}" optionLabel="${field.fieldOfAssociation.name}.${field.fieldOfAssociation.typeAsPojo.labelOrReferenceOrId.name}"  display="chip"></p-multiSelect>
                        </div>
                    <#elseif field.simple && !field.notVisibleInCreatePage>
                        <#if  field.type.simpleName == "Date" || field.dateTime>
                            <div class="field col-12 md:col-${pojo.columnStyle}">
                                <label for="${field?index}">${field.name18nCreate!'walo'}<#if field.requierd><span style="color: red;">*</span></#if></label>
                                <p-calendar appendTo="body" id="${field?index}"  [showTime]="true" [showSeconds]="false" placeholder="${field.name18nCreate!'walo'}"  [(ngModel)]="item.${field.name}"
                                            dateFormat="{{dateFormat}}" <#if field.requierd>[ngClass]="{'ng-invalid ng-dirty' : !valid${pojo.name?cap_first}${field.name?cap_first}}" </#if> >
                                </p-calendar>
                                <#if field.requierd><small class='p-error' *ngIf='!valid${pojo.name?cap_first}${field.name?cap_first}'>${field.name?cap_first} est obligatoire.</small></#if>
                            </div>
                        <#elseif  field.large>
                            <div class="field col-12 md:col-${pojo.columnStyle}">
                                <label for="${field?index}">${field.name18nCreate!'walo'}<#if field.requierd><span style="color: red;">*</span></#if></label>
                                <textarea id="${field?index}" pInputTextarea rows="5" cols="30" placeholder="${field.name18nCreate!'walo'}"  [(ngModel)]="item.${field.name}"
                                          <#if field.requierd>[ngClass]="{'ng-invalid ng-dirty' : !valid${pojo.name?cap_first}${field.name?cap_first}}" </#if> ></textarea>
                                <#if field.requierd><small class='p-error' *ngIf='!valid${pojo.name?cap_first}${field.name?cap_first}'>${field.name?cap_first} est obligatoire.</small></#if>
                            </div>
                        <#elseif field.pureString>
                            <div class="field col-12 md:col-${pojo.columnStyle}">
                                <label for="${field?index}">${field.name18nCreate!'walo'}<#if field.requierd><span style="color: red;">*</span></#if></label>
                                <input class="mb-2 mr-2" type="text" pInputText  placeholder="${field.name18nCreate!'walo'}" id="${field?index}" [(ngModel)]="item.${field.name}"
                                       <#if field.requierd>[ngClass]="{'ng-invalid ng-dirty' : !valid${pojo.name?cap_first}${field.name?cap_first}}" </#if> />
                                <#if field.requierd><small class='p-error' *ngIf='!valid${pojo.name?cap_first}${field.name?cap_first}'>${field.name?cap_first} est obligatoire.</small></#if>
                            </div>

                        <#elseif field.uploadOne>
                            <div class="field col-12 md:col-${pojo.columnStyle}">
                                <label for="${field?index}">${field.name18nCreate!'walo'}<#if field.requierd><span style="color: red;">*</span></#if></label>
                                <p-fileUpload name="files" [customUpload]="true" (uploadHandler)="uploadOne($event, 0)" [auto]="true" ></p-fileUpload>
                                <#if field.requierd><small class='p-error' *ngIf='!valid${pojo.name?cap_first}${field.name?cap_first}'>${field.name?cap_first} est obligatoire.</small></#if>
                            </div>


                        <#elseif field.bool>
                            <div class="field align-inputswitch col-12  md:col-${pojo.columnStyle}">
                                <div  class="label-inputswitch">
                                    <label for="${field?index}">${field.name18nCreate!'walo'}<#if field.requierd><span style="color: red;">*</span></#if></label>
                                </div>
                                <div class="input-switch">
                                    <p-inputSwitch id="${field?index}"  [(ngModel)]="item.${field.name}"
                                                   <#if field.requierd>[ngClass]="{'ng-invalid ng-dirty' : !valid${pojo.name?cap_first}${field.name?cap_first}}" </#if> >
                                    </p-inputSwitch>
                                    <#if field.requierd><small class='p-error' *ngIf='!valid${pojo.name?cap_first}${field.name?cap_first}'>${field.name?cap_first} est obligatoire.</small></#if>
                                </div>
                            </div>

                        <#elseif field.id == false>
                            <div class="field col-12 md:col-${pojo.columnStyle}">
                                <label for="${field?index}">${field.name18nCreate!'walo'}<#if field.requierd><span style="color: red;">*</span></#if></label>
                                <p-inputNumber class="mb-2 mr-2" id="${field?index}" placeholder="${field.name18nCreate!'walo'}" [(ngModel)]="item.${field.name}" <#if field.requierd>[ngClass]="{'ng-invalid ng-dirty' : !valid${pojo.name?cap_first}${field.name?cap_first}}" </#if> >
                                </p-inputNumber>
                                <#if field.requierd><small class='p-error' *ngIf='!valid${pojo.name?cap_first}${field.name?cap_first}'>${field.name?cap_first} est obligatoire.</small></#if>
                            </div>
                        </#if>

                    <#elseif field.generic && !field.notVisibleInCreatePage>
                        <div class="field col-11 md:col-<#if field.typeAsPojo.ignoreFront == false>${pojo.columnStyle -1}<#else >${pojo.columnStyle}</#if>">
                            <label for="${field?index}">${field.name18nCreate!'walo'}<#if field.requierd><span style="color: red;">*</span></#if></label>
                            <p-dropdown  appendTo="body"  [options]="${field.name}s" [(ngModel)]="item.${field.name}" id="${field?index}" [filter]="true" filterMatchMode="contains"
                                         [showClear]="true" optionLabel="<#if field.typeAsPojo??>${field.typeAsPojo.labelOrReferenceOrId.name}<#else>${field..name}</#if>" placeholder="${field.name18nCreate!'walo'}" <#if field.requierd>[ngClass]="{'ng-invalid ng-dirty' : !valid${pojo.name?cap_first}${field.name?cap_first}}" </#if> >
                            </p-dropdown>
                            <#if field.requierd><small class='p-error' *ngIf='!valid${pojo.name?cap_first}${field.name?cap_first}'>${field.name?cap_first} est obligatoire.</small></#if>
                        </div>
                        <#if field.typeAsPojo.ignoreFront == false && field.typeAsPojo.subModule.name == pojo.subModule.name>
                            <div class="col-1">
                                <label></label>
                                <button pButton pRipple type="button" icon="pi pi-plus" (click)="openCreate${field.typeAsPojo.name?cap_first}('${field.typeAsPojo.name?cap_first}')" class="p-button-success one-colonne-btn-success-align"></button>
                            </div>
                        </#if>
                    </#if>
                </#list>
            </div>
        </div>
    </#list>
    <#else>
        <TabView activeIndex={activeIndex} onTabChange={onTabChange}>
            <TabPanel header="${pojo.name}">
                <div className="formgrid grid">
                    <#list pojo.fields as field>
                    <#if field.list && field.association>
                    <div className="field col-6">
                        <label htmlFor="${field.name}">${field.fieldOfAssociation.formatedName}</label>
                        <MultiSelect value={item ? item.${field.name} : ''} options={${field.name}}  optionLabel="${field.fieldOfAssociation.name}.${field.fieldOfAssociation.typeAsPojo.labelOrReferenceOrId.name}" display="chip" placeholder="Select ${field.fieldOfAssociation.name}"  maxSelectedLabels={3}  onChange={(e) => onMultiSelectChange(e, '${field.name}')} />
                    </div>
                    <#elseif field.simple && !field.notVisibleInCreatePage>
                    <#if  field.type.simpleName == "Date" || field.dateTime>
                    <div className="field col-6">
                        <label htmlFor="${field.name}">${field.name?cap_first}</label>
                        <Calendar id="${field.name}" value={item ? item.${field.name} : ''} onChange={(e) => onInputDateChange(e, '${field.name}')} dateFormat="dd/mm/yy" showTime />
                    </div>
                    <#elseif  field.large>
                    <div className="field col-6">
                        <label htmlFor="${field.name}">${field.name?cap_first}</label>
                        <span className="p-float-label">
                            <InputTextarea id="${field.name?uncap_first}" value={item ? item.${field.name} : ''} onChange={(e) => onInputTextChange(e, '${field.name}')} rows={5} cols={30}/>
                        </span>
                    </div>
                    <#elseif field.pureString>
                    <div className="field col-6">
                        <label htmlFor="${field.name?uncap_first}">${field.name?cap_first}</label>
                        <InputText id="${field.name?uncap_first}" value={item ? item.${field.name} : ''} onChange={(e) => onInputTextChange(e, '${field.name?uncap_first}')} required autoFocus className={classNames({'p-invalid': submitted && !item.${field.name?uncap_first}})} />
                        {submitted && !item.${field.name?uncap_first} && <small className="p-invalid">${field.name?cap_first} is required.</small>}
                    </div>
                    <#elseif field.type.simpleName == "Boolean">
                    <div className="field col-6">
                    <div  class="label-inputswitch">
                        <label htmlFor="${field.name?uncap_first}">${field.name?cap_first}</label>
                        <span className="p-float-label">
                            <InputSwitch  id="${field.name}" checked={item ? item.${field.name} : ''} onChange={(e) => onBooleanInputChange(e, '${field.name}')} />
                        </span>
                    </div>
                    <#elseif field.id == false>
                    <div className="field col-6">
                        <label htmlFor="${field.name?uncap_first}">${field.name?cap_first}</label>
                        <InputNumber id="${field.name?uncap_first}" value={item ? item.${field.name} : 0} onChange={(e) => onInputNumerChange(e, '${field.name?uncap_first}')}/>
                    </div>
                    </#if>
                    <#elseif field.generic && !field.notVisibleInCreatePage>
                    <div className="field col-6">
                        <label htmlFor="${field.name?uncap_first}">${field.name?cap_first}</label>
                        <Dropdown  id="${field.name?uncap_first}Dropdown"  value={item ? item.${field.name} : ''} options={${field.name}s} onChange={(e) => onDropdownChange(e, '${field.name}')}   placeholder="Sélectionnez un ${field.name?uncap_first}" filter filterPlaceholder="Rechercher un ${field.name?uncap_first}" optionLabel="<#if field.typeAsPojo??>${field.typeAsPojo.labelOrReferenceOrId.name}<#else>${field..name}</#if>" />
                    </div>
                    </#if>
                    </#list>
                </div>
            < /TabPanel>
            <#list pojo.fields as field>
                <#if field.list && (field.associationComplex || field.fakeAssociation)>
            <TabPanel header="${field.name}">
                <#if !field.createAndListPageInOneTab>
                <TabView activeIndex={activeTab} onTabChange={(e) => setActiveTab(e.index)}>
                    <TabPanel header="Creation">
                        </#if>
                        <div className="grid">
                            <#list field.typeAsPojo.fields as innerField>
                            <#if  !innerField.notVisibleInCreatePage>
                            <#if innerField.dateTime>
                            <div className="field col-6">
                                <label htmlFor="${innerField.name}">${innerField.name}</label>
                                <Calendar id="${innerField.name}" value={${field.typeAsPojo.name?uncap_first}?.${innerField.name}}  onChange={(e) => onInputDateChange${field.name?cap_first}(e, '${innerField.name?uncap_first}')} dateFormat="dd/mm/yy" showTime  />
                            </div>
                            <#elseif innerField.pureString>
                            <div className="field col-6">
                                <label htmlFor="${innerField.name}">${innerField.name?cap_first}</label>
                                <InputText id="${innerField.name}" value={${field.typeAsPojo.name?uncap_first}.${innerField.name}} onChange={(e) => onInputTextChange${field.name?cap_first}(e, '${innerField.name?uncap_first}')} required autoFocus className={classNames({'p-invalid': submitted && !item.${field.name?uncap_first}})}/>
                            </div>
                            <#elseif innerField.bool>
                            <div className="field col-6">
                                <label htmlFor="${innerField.name}">${innerField.name?cap_first}</label>
                                <span className="p-float-label">
                                    <InputSwitch  id="${innerField.name}" checked={${field.typeAsPojo.name?uncap_first}.${innerField.name}} onChange={(e) => onBooleanInputChange${field.name?cap_first}(e, '${innerField.name?uncap_first}')} />
                                </span>
                            </div>
                            <#elseif innerField.simple && innerField.id == false>
                            <div className="field col-6">
                                <label htmlFor="${innerField.name?uncap_first}">${innerField.name?cap_first}</label>
                                <InputNumber id="${innerField.name}" value={${field.typeAsPojo.name?uncap_first}.${innerField.name}}  onValueChange={(e) => onInputNumerChange${field.name?cap_first}(e, '${innerField.name?uncap_first}')}/>
                            </div>
                            <#elseif innerField.generic && innerField.typeAsPojo.name != pojo.name>
                            <div className="field col-6">
                                <label htmlFor="${innerField.name}">${innerField.formatedName}</label>
                                <Dropdown id="${innerField.name?uncap_first}Dropdown" value={${field.typeAsPojo.name?uncap_first}.${innerField.name}} options={${innerField.name?uncap_first}s} onChange={(e) => onDropdownChange${field.name?cap_first}(e, '${innerField.name?uncap_first}')} placeholder="Sélectionnez un ${innerField.name}" filter  filterPlaceholder="Rechercher un ${innerField.name?uncap_first}"  optionLabel="${innerField.typeAsPojo.labelOrReferenceOrId.name!'walo'}" />
                            </div>
                            <#elseif innerField.list && innerField.association>
                            <div className="field col-6">
                                <label htmlFor="${innerField.name}">${innerField.fieldOfAssociation.formatedName}</label>
                                <MultiSelect value={${field.typeAsPojo.name?uncap_first}.${innerField.name}} options={${innerField.name}}  optionLabel="$${innerField.fieldOfAssociation.name}.${innerField.fieldOfAssociation.typeAsPojo.labelOrReferenceOrId.name}" display="chip" placeholder="Select ${innerField.fieldOfAssociation.formatedName}"  maxSelectedLabels={3}  onChange={(e) => onMultiSelectChange${field.name?cap_first}(e, '${innerField.name}')} />
                            </div>
                            </#if>
                            </#if>
                            </#list>
                            <div className="field col-1">
                                <Button icon="pi pi-plus" label="OK" className="mt-4" onClick={add${field.name?cap_first}} />
                            </div>
                        </div>
                        <#if !field.createAndListPageInOneTab>
                    </TabPanel>
                    <TabPanel header="Liste">
                        </#if>
                        <#if field.createAndListPageInOneTab>
                        <div class="p-col">
                        </#if>
                        <div className="card">
                            <DataTable value={item.${field.name?uncap_first}} tableStyle={{minWidth: '50rem'}} dataKey="id">
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
                                <Column header="Actions" body={(rowData) => (
                                    <div>
                                        <Button icon="pi pi-times" rounded severity="warning" className="mr-2 p-button-danger" onClick={()=> delete${field.typeAsPojo.name}(rowData)} />
                                        <Button icon="pi pi-pencil" rounded severity="success" className="mr-2" onClick={()=> edit${field.typeAsPojo.name}(rowData)} />
                                    </div>
                                )}></Column>
                            </DataTable>
                        </div>
                        <#if field.createAndListPageInOneTab>
                        </div>
                        <#else>
                    </TabPanel>
                </TabView>
                </#if>
            </TabPanel>
                </#if>
            </#list>
        </TabView>
    </#if>
    <#if pojo.createUpdateConfounded>
    </div>
    <#else>
    </Dialog>
    </#if>
);
};
export default Edit;


