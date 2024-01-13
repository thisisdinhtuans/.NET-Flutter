using api.Dto;
using api.Models;
using api.ViewModel;
using AutoMapper;

namespace api.Helper
{
    public class MappingProfiles:Profile
    {
        public MappingProfiles()
        {
            CreateMap<Person, PersonDto>();
            CreateMap<PersonDto, Person>();

            CreateMap<Person, PersonViewModel>();
            CreateMap<PersonViewModel, Person>();
        }
    }
}
