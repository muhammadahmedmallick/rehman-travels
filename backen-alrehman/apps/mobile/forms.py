"""
Forms for mobile app
"""
from django import forms


class CSVImportForm(forms.Form):
    """
    Form for uploading visa CSV files for bulk import
    """
    visa_types_csv = forms.FileField(
        label='Visa Types CSV File',
        help_text='Upload the visa types (parent categories) CSV file',
        widget=forms.FileInput(attrs={
            'accept': '.csv',
            'class': 'vFileField'
        })
    )

    variants_csv = forms.FileField(
        label='Visa Variants CSV File',
        help_text='Upload the visa variants (child options) CSV file',
        widget=forms.FileInput(attrs={
            'accept': '.csv',
            'class': 'vFileField'
        })
    )

    clear_existing = forms.BooleanField(
        label='Clear Existing Data',
        help_text='Check this to delete all existing visa data before importing. ⚠️ WARNING: This cannot be undone!',
        required=False,
        initial=False,
        widget=forms.CheckboxInput(attrs={
            'class': 'vCheckbox'
        })
    )

    def clean(self):
        cleaned_data = super().clean()
        visa_types_csv = cleaned_data.get('visa_types_csv')
        variants_csv = cleaned_data.get('variants_csv')

        # Validate file extensions
        if visa_types_csv:
            if not visa_types_csv.name.endswith('.csv'):
                raise forms.ValidationError({
                    'visa_types_csv': 'Please upload a CSV file for visa types.'
                })

        if variants_csv:
            if not variants_csv.name.endswith('.csv'):
                raise forms.ValidationError({
                    'variants_csv': 'Please upload a CSV file for variants.'
                })

        return cleaned_data
