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
import {MultiSelect} from "primereact/multiselect";
import {MessageService} from "/pages/controller/service/MessageService";
import {EffetIndesirableService} from '/pages/controller/service/EffetIndesirable.service';
import  {EffetIndesirableDto}  from '/pages/controller/model/EffetIndesirable.model';
import {RendezVousDto} from '/pages/controller/model/RendezVous.model';
import {RendezVousService} from '/pages/controller/service/RendezVous.service';
const Create = ({visible, onClose, add, showToast, list}) => {

    const emptyItem = new EffetIndesirableDto();
    const [items, setItems] = useState<EffetIndesirableDto[]>([list]);
    const [item, setItem] = useState<EffetIndesirableDto>(emptyItem);
    const [submitted, setSubmitted] = useState(false);
    const [activeIndex, setActiveIndex] = useState<number>(0);
    const [activeTab, setActiveTab] = useState(0);
    const [rendezVouss, setRendezVouss] = useState<RendezVousDto[]>([]);
    type RendezVousResponse = AxiosResponse<RendezVousDto[]>;

    useEffect(() => {
        const fetchData = async () => {
            try {
                const [rendezVoussResponse ] = await Promise.all<RendezVousResponse>([
                    RendezVousService.getList(),
                ]);
                setRendezVouss(rendezVoussResponse.data);
            } catch (error) {
                console.error(error);
            }
        };
        fetchData();
    }, []);

    const onDropdownChange = (e, field) => {
        setItem((prevState) => ({ ...prevState, [field]: e.value}));
    };


    const onTabChange = (e: { index: number }) => { setActiveIndex(e.index); };

    const hideDialog = () => {
        setSubmitted(false);
        onClose();
    };

    const saveItem = async () => {
        setSubmitted(true);
        let _items = [...items];
        let _item = {...item};
        if (!_item.id) {
            const response = await EffetIndesirableService.save(_item);
			_item.id = response.data.id;
            _items.push(_item);
            add(_item);
            MessageService.showToast(showToast, { severity: 'success', summary: 'Successful', detail: 'EffetIndesirable Created', life: 3000 });
        }
        setItems(_items);
        onClose();
        setItem(emptyItem);
    };

    const onInputTextChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>, name: string) => {
        const val = (e.target && e.target.value) || '';
        let _item = {...item};
        _item[`${name}`] = val;
        setItem(_item);
    };

    const onInputDateChange = (e: CalendarChangeEvent, name: string) => {
        const val = e.value || ''; // Utilisez e.value au lieu de e.target.value
        let _item = { ...item};
        _item[`${name}`] = val;
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
    <Dialog visible={visible} style={{width: '70vw'}} header="EffetIndesirable" modal className="p-fluid" footer={itemDialogFooter} onHide={hideDialog} >
        <TabView activeIndex={activeIndex} onTabChange={onTabChange}>
            <TabPanel header="EffetIndesirable">
                <div className="formgrid grid">
                    <div className="field col-6">
                    <label htmlFor="rendezVous">RendezVous</label>
                    <Dropdown  id="rendezVousDropdown"  value={item.rendezVous} options={rendezVouss} onChange={(e) => onDropdownChange(e, 'rendezVous')}   placeholder="Sélectionnez un rendezVous" filter filterPlaceholder="Rechercher un rendezVous" optionLabel="id" />
                    </div>
                    <div className="field col-6">
                    <label htmlFor="dateFait">DateFait</label>
                    <Calendar id="dateFait" value={item.dateFait} onChange={(e) => onInputDateChange(e, 'dateFait')} dateFormat="dd/mm/yy" showTime />
                    </div>
                    <div className="field col-6">
                    <label htmlFor="description">Description</label>
                    <span className="p-float-label">
                    <InputTextarea id="description" value={item.description} onChange={(e) => onInputTextChange(e, 'description')} rows={5} cols={30}/>
                    </span>
                    </div>
                </div>
            </TabPanel>
        </TabView>
    </Dialog>
);
};
export default Create;
