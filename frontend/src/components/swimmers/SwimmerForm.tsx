import { useState } from 'react';
import type { Swimmer } from '../../types/swimmer.types';
import { Button } from '../common/Button';
import { Input } from '../common/Input';
import { Select } from '../common/Select';

interface SwimmerFormProps {
  initialData?: Partial<Swimmer>;
  onSubmit: (data: Partial<Swimmer>) => void;
  onCancel: () => void;
  isLoading?: boolean;
}

export const SwimmerForm: React.FC<SwimmerFormProps> = ({
  initialData,
  onSubmit,
  onCancel,
  isLoading = false,
}) => {
  const [formData, setFormData] = useState<Partial<Swimmer>>({
    first_name: initialData?.first_name || '',
    last_name: initialData?.last_name || '',
    dob: initialData?.dob || '',
    sex: initialData?.sex || 'M',
    club: initialData?.club || '',
    se_membership_id: initialData?.se_membership_id || '',
  });

  const [errors, setErrors] = useState<Record<string, string>>({});

  const validate = () => {
    const newErrors: Record<string, string> = {};

    if (!formData.first_name?.trim()) {
      newErrors.first_name = 'First name is required';
    }

    if (!formData.last_name?.trim()) {
      newErrors.last_name = 'Last name is required';
    }

    if (!formData.dob) {
      newErrors.dob = 'Date of birth is required';
    } else {
      const dob = new Date(formData.dob);
      const today = new Date();
      if (dob > today) {
        newErrors.dob = 'Date of birth cannot be in the future';
      }
    }

    if (!formData.club?.trim()) {
      newErrors.club = 'Club is required';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (validate()) {
      onSubmit(formData);
    }
  };

  const handleChange = (field: keyof Swimmer, value: string) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
    // Clear error for this field
    if (errors[field]) {
      setErrors((prev) => {
        const newErrors = { ...prev };
        delete newErrors[field];
        return newErrors;
      });
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Input
          label="First Name"
          value={formData.first_name || ''}
          onChange={(e) => handleChange('first_name', e.target.value)}
          error={errors.first_name}
          required
        />

        <Input
          label="Last Name"
          value={formData.last_name || ''}
          onChange={(e) => handleChange('last_name', e.target.value)}
          error={errors.last_name}
          required
        />

        <Input
          type="date"
          label="Date of Birth"
          value={formData.dob || ''}
          onChange={(e) => handleChange('dob', e.target.value)}
          error={errors.dob}
          required
        />

        <Select
          label="Sex"
          value={formData.sex || 'M'}
          onChange={(e) => handleChange('sex', e.target.value)}
          options={[
            { value: 'M', label: 'Male' },
            { value: 'F', label: 'Female' },
          ]}
          required
        />

        <Input
          label="Club"
          value={formData.club || ''}
          onChange={(e) => handleChange('club', e.target.value)}
          error={errors.club}
          required
        />

        <Input
          label="SE Membership ID"
          value={formData.se_membership_id || ''}
          onChange={(e) => handleChange('se_membership_id', e.target.value)}
          placeholder="Optional"
        />
      </div>

      <div className="flex gap-4 justify-end">
        <Button type="button" variant="secondary" onClick={onCancel}>
          Cancel
        </Button>
        <Button type="submit" isLoading={isLoading}>
          {initialData?.id ? 'Update Swimmer' : 'Create Swimmer'}
        </Button>
      </div>
    </form>
  );
};
