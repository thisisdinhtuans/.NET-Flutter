using api.Dto;
using api.Interfaces;
using api.Models;
using api.ViewModel;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;

namespace api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PersonController : Controller
    {
        private readonly IPersonRepository _personRepository;
        private readonly IMapper _mapper;
        public PersonController(IPersonRepository personRepository, IMapper mapper)
        {
            _personRepository = personRepository;
            _mapper = mapper;
        }
        [HttpGet("read")]
        [ProducesResponseType(200, Type=typeof(IEnumerable<Person>))]
        public IActionResult GetPersons() {
            var persons=_personRepository.GetPersons();
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(persons);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(200, Type=typeof(Person))]
        [ProducesResponseType(400)]
        public IActionResult GetPerson(int id)
        {
            if(!_personRepository.PersonExits(id))
            {
                return NotFound();
            }
            var person=_personRepository.GetPerson(id);
            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(person);
        }

        [HttpPost("create")]
        [ProducesResponseType(204)]
        [ProducesResponseType(400)]
        public IActionResult CreatePerson([FromBody] PersonViewModel personCreate)
        {

            if (personCreate == null)
                return BadRequest(ModelState);
            var person = _personRepository.GetPersons()
                .Where(c => c.lastname.Trim().ToUpper() == personCreate.lastname.TrimEnd().ToUpper())
                .FirstOrDefault();
            if (person != null)
            {
                ModelState.AddModelError("", "Person already exits");
                return StatusCode(422, ModelState);
            }
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            //Person.create
            var personMap = _mapper.Map<Person>(personCreate);
            personMap.createdat = DateTime.Now;
            if (!_personRepository.CreatePerson(personMap))
            {
                ModelState.AddModelError("", "Something went wrong while saving");
                return StatusCode(500, ModelState);
            }
            return Ok("Succesfully Created");
        }

        [HttpPut("edit")]
        [ProducesResponseType(400)]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public IActionResult UpdateCategory( [FromBody] PersonDto updatedPerson)
        {
            if (updatedPerson == null)
                return BadRequest(ModelState);
            //if (personId != updatedPerson.id)
            //    return BadRequest(ModelState);
            //if (!_personRepository.PersonExits(personId))
            //    return NotFound();
            if (!ModelState.IsValid)
                return BadRequest();
            //var person=_personRepository.GetPerson(personId);
            var personMap = _mapper.Map<Person>(updatedPerson);
            personMap.createdat = DateTime.Now;
            if (!_personRepository.UpdatePerson(personMap))
            {
                ModelState.AddModelError("", "Something went wrong updating person");
                return StatusCode(500, ModelState);
            }
            return NoContent();
        }

        [HttpDelete("delete/{personId}")]
        [ProducesResponseType(400)]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public IActionResult DeleteCategory(int personId)
        {
            if (!_personRepository.PersonExits(personId))
            {
                return NotFound();
            }
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            if (!_personRepository.DeletePerson(personId))
            {
                ModelState.AddModelError("", "Something went wrong deleting person");
            }
            return NoContent();
        }
    }
}
