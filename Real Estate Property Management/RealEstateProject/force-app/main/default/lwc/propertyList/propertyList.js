import { LightningElement, wire, track } from 'lwc';
import getProperties from '@salesforce/apex/PropertyController.getProperties';

export default class PropertyList extends LightningElement {
    @track properties = [];
    @track totalRecords = 0;
    @track pageSize = 25;
    @track currentPage = 1;
    @track totalPages = 0;
    @track filters = {
        minPrice: null,
        maxPrice: null,
        status: '',
        furnishingStatus: '',
        nearbyDistance: null,
        userLatitude: null,
        userLongitude: null
    };

    @wire(getProperties, { 
        pageNumber: '$currentPage', 
        pageSize: '$pageSize', 
        filters: '$filters'
    })
    wiredProperties({ error, data }) {
        if (data) {
            this.properties = data.records;
            this.totalRecords = data.totalCount;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        } else if (error) {
            console.error('Error fetching properties:', error);
        }
    }

    handleFilterChange(event) {
        const { name, value } = event.target;
        this.filters = { ...this.filters, [name]: value };
    }

    handlePageChange(event) {
        const direction = event.target.dataset.page;
        if (direction === 'next') {
            this.currentPage += 1;
        } else {
            this.currentPage -= 1;
        }
    }
}